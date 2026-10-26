# Design Decisions

## Users and ownership

All accounts use the `users` table. A property belongs to a user, and its listings reference that property. A user can also have applications, reviews, saved listings, and reports. The `is_moderator` boolean distinguishes moderator records; `has_secure_password` stores password hashes and provides password authentication at the model level.

## Neighborhoods, amenities, and saved listings

Neighborhoods have their own table so properties reference a shared catalog entry. The `Neighborhood` model validates that each name is present and unique, ignoring case. Deleting a neighborhood with properties is blocked by `dependent: :restrict_with_error`.

Properties and amenities use the `property_amenities` join table. Both the model validation and a unique index on `(property_id, amenity_id)` prevent duplicate assignments.

Saved listings link users to listings. A model validation and a unique index on `(user_id, listing_id)` prevent a user from saving the same listing twice.

## Status values

The migrations define PostgreSQL enum types, and the models map them through Rails enums:

| Model | Attribute | Values |
| --- | --- | --- |
| Property | `property_type` | `apartment`, `house` |
| Listing | `status` | `draft`, `published`, `reserved`, `rented`, `withdrawn` |
| Application | `status` | `pending`, `shortlisted`, `accepted`, `rejected`, `withdrawn` |
| Visit | `status` | `proposed`, `confirmed`, `completed`, `cancelled` |
| Report | `status` | `pending`, `reviewed`, `dismissed`, `action_taken` |

These types restrict the values stored in each column. Model scopes select records by status, such as `Listing.published`, `Application.shortlisted`, and `Visit.completed`.

## Applications and dates

An application belongs to a user and a listing. A model validation and a unique index on `(user_id, listing_id)` allow at most one application per user per listing.

On creation, listings reject availability dates before today, and applications reject move-in dates before today. A visit rejects a timestamp earlier than its application's creation time; an equal timestamp passes that validation.

## Reviews

A review belongs to a visit, a property, and a user. Its comment must be present, and its rating must be an integer from 1 to 5.

`Review#visit_must_be_completed` rejects a review whose associated visit is not completed. The uniqueness validation on `visit_id` and the unique database index allow **at most one review per visit**. A completed visit may have no review.

## Prices and numeric fields

`monthly_rent` and `deposit` are expressed in UF and stored as `decimal(8, 2)`, for example 9.50 UF. The model requires rent to be greater than zero and the deposit to be zero or greater. `Listing.under_rent` compares rents in the same unit.

Room counts, stay lengths, and ratings use `smallint` columns. Model validations require nonnegative bedroom and bathroom counts, positive stay lengths, and ratings between 1 and 5.

## Text validations

Names in the neighborhood and amenity catalogs must be present and unique, ignoring case. Users require first and last names and a correctly formatted email address that is unique, ignoring case.

Application messages, review comments, and report details are required. Reports also require a reason, listings require a title, and properties require an address.

## Sample data

`db/seeds.rb` deletes existing domain records in reverse dependency order and creates the sample dataset. Repeated runs replace those records rather than adding another copy. The seed assigns statuses directly and includes multiple properties, applications to the same listing, visits, and reviews linked to completed visits.
