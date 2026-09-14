# Design Decisions

## 1. Additional Entities Introduced (Not Explicit in the Project Description)

* **`neighborhoods` (Catalog Table):**
  * *Rationale:* Instead of using an `enum` or a plain text field in `properties`, we modeled a dedicated `neighborhoods` table. This satisfies the explicit project requirement that moderators must manage the neighborhood catalog dynamically through the web interface without modifying application code or running new migrations. It also normalizes search filter inputs and prevents inconsistent spellings. Visitors and regular members have read-only access, while moderators have full administrative CRUD permissions.
* **`amenities` and `property_amenities` (Many-to-Many Relationship):**
  * *Rationale:* A property can offer multiple amenities (e.g., Wi-Fi, laundry, parking, pets allowed), and a single amenity applies to many properties. We resolved this Many-to-Many ($N:M$) relationship through the `property_amenities` join table with a composite unique index on `(property_id, amenity_id)`. Like neighborhoods, amenities are managed as an administrative catalog by moderators.
* **`saved_listings` (Bookmarks Join Table):**
  * *Rationale:* To support the requirement that seekers can bookmark listings to review later, we introduced `saved_listings` linking `user_id` and `listing_id` with a unique index to prevent duplicate saves.

---

## 2. Representation of Lifecycles

### Listing Lifecycle (`listing_status`)
Modeled as an `enum` column `status` on the `listings` table with the following transitions:
* `draft`: Initial state during authoring; visible only to the owning host.
* `published`: Open to public search and actively receiving applications.
* `reserved`: An applicant has been accepted; new applications are blocked.
* `rented`: The accepted seeker has formally moved in.
* `withdrawn`: Delisted by the host or taken down by a moderator (voiding pending applications).

### Application Lifecycle (`application_status`)
Modeled as an `enum` column `status` on the `applications` table:
* `pending`: Submitted by the seeker; awaiting host review.
* `shortlisted`: The host expresses interest and unlocks visit scheduling.
* `accepted`: Chosen applicant for the room.
* `rejected`: Dismissed by the host, or automatically rejected when another applicant is accepted.
* `withdrawn`: Voluntarily pulled back by the seeker.

### Atomic Selection Rule
Accepting an applicant is an all-or-nothing database transaction:
1. The chosen application transitions to `accepted`.
2. All other `pending` or `shortlisted` applications on that listing transition to `rejected`.
3. The listing transitions from `published` to `reserved`.

---

## 3. Domain Assumptions & Architectural Choices

1. **Unified `users` Table with `is_moderator` Boolean:**
   * Rather than maintaining separate tables or complex roles for hosts, seekers, and moderators, all registered accounts exist in a single `users` table. Ownership determines permissions (a member acts as a host on their own listings and as a seeker on others).
   * Moderation privileges are represented via a simple `is_moderator: boolean` flag (`default: false`), which is space-efficient (1 byte) and idiomatically maps to Rails predicate methods (`current_user.is_moderator?`) and Pundit authorization policies.
2. **Visitors are Unauthenticated and Not Persisted:**
   * Visitors are anonymous guests. No records are created in `users` or any other table for browsing or searching.
3. **Strict Gate on Reviews (1:1 with Completed Visits):**
   * A seeker can only review a property after completing a physical visit. We enforce this by linking `reviews.visit_id` with a unique constraint (`ref: - visits.id`), guaranteeing exactly one review per completed visit and preventing unverified ratings.
4. **Storage Optimization with `smallint` for Low-Magnitude Numeric Attributes:**
   * Attributes with naturally constrained integer ranges—such as `bedrooms_count` and `bathrooms_count` in `properties`, `minimum_stay_months` in `listings`, `intended_stay_months` in `applications`, and `rating` (1–5) in `reviews`—are typed as `smallint` (2 bytes / 16 bits) instead of standard 4-byte `integer`. A range of up to 32,767 covers real-world household values while reducing storage and index footprint in PostgreSQL.
5. **Currency and Price Representation (UF - Unidad de Fomento):**
   * Rental prices in Chile are standardly indexed to UF (Unidad de Fomento). Monetary amounts (`monthly_rent` and `deposit` in `listings`) are modeled as `decimal(8, 2)` (or integer cents of UF) to accurately record amounts with two decimal places (e.g., 9.50 UF) while preventing floating-point rounding inaccuracies.
6. **String Length Boundaries and Text Constraints:**
   * Short identifiers and single-line attributes (`name` in catalogs, `first_name`, `last_name`, `email_address`, `address`, `phone_number`) are modeled as `varchar` (with expected application-level limits, e.g., 50–255 characters).
   * Free-text fields have explicit length constraints enforced in model validations:
     * `reviews.comment`: Capped at a maximum length (e.g., 500 characters, Twitter-style) with a minimum of 10 characters to ensure feedback is substantive yet concise and readable on the property page.
     * `applications.message`: Capped at 1,000 characters to encourage focused personal introductions without overloading hosts.
     * `reports.details`: Capped at 500 characters for clear, actionable moderation triage.
