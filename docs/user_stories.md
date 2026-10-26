# Roomies — Model Scenarios

These scenarios describe the records, queries, and validations implemented in the Rails models.

## Find listings

`Listing.published` selects listings with published status. `Listing.in_neighborhood(id)` filters through the property's neighborhood, `Listing.under_rent(amount)` applies a maximum monthly rent in UF, and `Listing.available_from(date)` selects availability dates on or after the given date. These scopes can be chained.

## Record a property and its rooms

A property belongs to a user and a neighborhood and records its address, type, bedroom and bathroom counts, and shared spaces. Its amenities are associated through `property_amenities`.

Each listing belongs to a property and records a title, rent and deposit in UF, availability date, minimum stay, furnishing and private bathroom flags, and status. The model validates required fields, prices, stay length, and the availability date on creation.

## Record an application

An application links a user to a listing and records a message, move-in date, intended stay, and status. The model requires the message and dates, validates a positive stay length, and rejects past move-in dates on creation. A user can have at most one application per listing.

## Record a visit

A visit belongs to an application and records a timestamp, notes, and status. The timestamp is required and cannot precede the application's creation time. `Visit.upcoming` selects visits whose timestamp is on or after the current time.

## Review a completed visit

A review links a visit, property, and user and records a required comment and an integer rating from 1 to 5. Its associated visit must be completed. A visit may have zero or one review. `Review.positive` selects ratings of 4 or 5.

## Save a listing

`SavedListing` links a user to a listing. The model and database enforce uniqueness for that pair.

## Record a report

A report belongs to a user and a listing and records a required reason and details, plus a status. `Report.pending` selects pending reports, and `Report.actioned` selects reports with `action_taken` status.
