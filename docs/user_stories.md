# Roomies - User Stories

## Roles and Permissions

The platform uses role-based access control with three roles:
* **Visitors (not signed in):** can browse and search published listings, view listing and property details, and read reviews. They cannot apply, save, review, or report.
* **Members (Host/Seeker):** everything a visitor can do, plus publishing their own properties and listings, managing the applications received on their own listings, applying to other people’s listings, arranging visits, saving listings, reviewing properties they visited, and reporting listings. A member acts as a host on the listings they own and as a seeker on everyone else’s.
* **Moderators:** everything a member can do, plus reviewing reports, taking down any listing, removing any review, and managing the neighborhood and amenity catalogs.

Ownership, not the role, is what determines most of the permissions in Roomies. Anyone can be a host and a seeker at the same time; what a member may do to a record depends on whether the record is theirs.

---

## 1. Searching and Browsing Listings as a Visitor Who Is Not Signed In

### Browse Published Room Listings
> As a Visitor,  
> I want to browse a public catalog of published room listings without having an account,  
> so that I can assess available rooms and decide if Roomies fits my housing needs.

---

### Search and Filter Listings
> As a Visitor,  
> I want to filter available rooms by neighborhood, maximum monthly rent, availability date, and specific amenities,  
> so that I can quickly locate rooms matching my budget and essential living preferences.

---

### View Room Details and Reviews
> As a Visitor,  
> I want to view the full details of a room listing, including photos, description, property amenities, and past visitor reviews,  
> so that I can thoroughly evaluate the living conditions before deciding to register and apply.

---

## 2. Publishing a Property and the Listings Inside It

### Register a Property with Shared Amenities
> As a Host,  
> I want to register my residential property with its address, neighborhood, property type, room count, and amenities,  
> so that I establish the physical home container where my rooms will be listed.

---

### Publish a Room Listing
> As a Host,  
> I want to create a listing for an available room with pricing, availability dates, photos, and rich-text house rules,  
> so that prospective seekers can discover the room and apply.

---

## 3. Applying to a Listing and Withdrawing an Application

### Apply to an Available Room Listing
> As a Seeker,  
> I want to submit an application with an introductory message, my target move-in date, and expected length of stay,  
> so that the host can review my profile and evaluate if I am a good match for the home.

---

### Withdraw a Submitted Application
> As a Seeker,  
> I want to withdraw my pending or shortlisted application,  
> so that the host knows I am no longer interested and my application is removed from active consideration.

---

## 4. Shortlisting Applications, Arranging a Visit, and Accepting One Applicant

### Review Applications and Shortlist Candidates
> As a Host,  
> I want to review applications submitted to my listings and shortlist promising applicants,  
> so that I can filter candidates of interest and proceed to organize visits.

---

### Propose and Schedule a Property Visit
> As a Host,  
> I want to propose visit dates to shortlisted applicants and mark visits as completed once conducted,  
> so that we can meet prospective roommates and enable verified reviews.

---

### Confirm or Decline a Proposed Visit
> As a Seeker,  
> I want to confirm or decline a visit date and time proposed by the host,  
> so that we can agree on an in-person meeting to inspect the room and meet the housemates.

---

### Accept a Housemate and Reserve the Listing (Atomic Decision)
> As a Host,  
> I want to accept exactly one applicant for my published room listing,  
> so that I confirm my new housemate, close the listing to further applications, and reject remaining candidates.

---

## 5. Reviewing a Property After Visiting It

### Submit a Verified Property Review
> As a Seeker,  
> I want to leave a rating (1 to 5 stars) and a written comment about a property after completing a visit,  
> so that future seekers know whether the property matches what the listing promised.

---

## 6. Saving Listings and Reporting a Listing

### Save Listings to Personal Favorites
> As a Seeker,  
> I want to bookmark published room listings to a personal saved list,  
> so that I can easily monitor their availability and compare options later.

---

### Report a Suspicious or Fraudulent Listing
> As a Member,  
> I want to report a listing that appears fraudulent, misleading, or offensive, specifying the reason for my report,  
> so that the moderation team can investigate and protect the community from scams.

---

## 7. Moderation of Reported Listings and Catalog Management

### Triage Reports and Take Down Infringing Listings
> As a Moderator,  
> I want to review submitted user reports and take down listings that violate platform standards,  
> so that fraudulent, inaccurate, or harmful listings are promptly removed from public visibility.

---

### Remove Inappropriate or Abusive Reviews
> As a Moderator,  
> I want to inspect and remove reviews that contain abusive language, spam, or defamatory content,  
> so that property ratings remain constructive, honest, and respectful.

---

### Manage Neighborhood and Amenity Catalogs
> As a Moderator,  
> I want to create, update, and manage official catalogs of neighborhoods and amenities,  
> so that hosts and seekers use standardized, clean data for searching, filtering, and listing properties.
