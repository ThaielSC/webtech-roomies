# Roomies

Roomies models shared housing: users, properties, room listings, applications, visits, reviews, saved listings, and reports. Built for the Web Technologies course.

## Team

- Thaiel Santiago
- Cristóbal Toro

## Requirements

- Ruby 4.0.6, as specified in `.ruby-version`, and Bundler
- Rails 8.1.4, installed through Bundler
- PostgreSQL 16 or later, running locally
- Node.js 26.10.0, as specified in `.node-version`, and Yarn

The frontend assets use Bootstrap 5.3 and Sass.

Listing photographs accept JPEG, PNG, and WebP files up to **5 MB per image**. Image variants use the `image_processing` and `ruby-vips` gems plus the system libvips package; install libvips for your operating system before processing uploaded photographs.

## Local setup

Clone the repository and install the dependencies:

```bash
git clone https://github.com/ThaielSC/webtech-roomies.git
cd webtech-roomies
bundle install
yarn install
```

Check that PostgreSQL is running:

```bash
pg_isready
```

By default, `config/database.yml` connects through a local socket using a PostgreSQL role with the same name as your operating system user. That role needs permission to create databases. If it does not exist, create it using a PostgreSQL administrator account:

```bash
createuser --createdb "$USER"
```

On Linux installations that use the `postgres` administrator account, run `sudo -u postgres createuser --createdb "$USER"` instead. If you use a different database user or a TCP connection, set `username`, `password`, and `host` in the development and test sections of `config/database.yml` to match your local installation.

Create the databases, run the migrations, and load the sample records:

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

Start the Rails server and the CSS watcher:

```bash
bin/dev
```

`bin/dev` installs Foreman if needed, then starts the processes in `Procfile.dev`. Open `http://localhost:3000/up` to check that Rails responds. You can inspect the records with `bin/rails console`.

## Sample data

The seed creates:

- 12 neighborhoods and 14 amenities
- 13 users: one moderator and 12 regular users
- 6 properties and 9 listings: 5 published, 1 draft, 1 reserved, 1 rented, and 1 withdrawn
- 9 applications, 6 visits, and 3 reviews
- 6 saved listings and 3 reports

Monthly rent and deposits are expressed in **UF**, stored as `decimal(8, 2)`. The sample rents range from 7.00 to 11.50 UF.

All sample users have the password `password123`. Example records include `moderador@roomies.cl` and `camila.soto@ejemplo.cl`.

Each review belongs to a completed visit. A visit can have at most one review, enforced by a model validation and a unique database index.

Running the seed again deletes the existing domain records and recreates the sample data. Use it in a local database whose records you can replace.

## Querying the models

Run these examples in `bin/rails console`:

```ruby
# Listings with published status
Listing.published

# Listings available on or after today
Listing.available_from(Date.current)

# Listings with monthly rent of at most 9.50 UF
Listing.under_rent(BigDecimal("9.50"))

# Applications by status
Application.pending
Application.shortlisted

# Reviews rated at least 4 out of 5
Review.positive
```

## Documentation

- [Design decisions](docs/design_decisions.md)
- [Model scenarios](docs/user_stories.md)
- [DBML specification](docs/domain_model.dbml)
- [Domain diagram](docs/diagram.svg)
- [Static landing prototype](landing/)

![Roomies domain model](docs/diagram.svg)

## Authentication and Authorization

Roomies implements authentication using the native Rails 8 authentication system and authorization using the Pundit gem.

### Authentication

Registered users can:

- Create an account with their name, email, and password.
- Log in and log out.
- Reset their password through email.
- View and edit their profile.
- Maintain authenticated sessions using secure cookies.

Passwords are securely hashed using `has_secure_password` and bcrypt. Sessions are stored in the database.

Unauthenticated users can browse public content, but actions requiring an account redirect them to the login page.

### User roles

Roomies supports two registered user roles:

| Role | Description |
|------|-------------|
| `member` | Default role assigned to registered users. |
| `moderator` | Administrative role with additional moderation permissions. |

Visitors are unauthenticated users and do not have an assigned role.

### Authorization with Pundit

Authorization is enforced through Pundit policies and policy scopes.

| Resource | Permissions |
|----------|-------------|
| Properties | Authenticated users can create properties. Owners and moderators can edit or delete them. |
| Listings | Published listings are publicly accessible. Owners and moderators can manage listings, including unpublished ones. |
| Applications | Authenticated users can apply to listings they do not own. Applicants, hosts, and moderators can access relevant applications. Only hosts can manage application decisions. |
| Visits | Applicants and hosts can manage visits associated with their applications, subject to visit status restrictions. |
| Reviews | Members can submit reviews after completing an eligible visit. Authors and moderators can delete reviews. |
| Reports | Authenticated users can report listings. Moderators can review and resolve reports. |
| Neighborhoods | Publicly accessible for viewing. Only moderators can create, edit, or delete neighborhoods. |
| Amenities | Publicly accessible for viewing. Only moderators can create, edit, or delete amenities. |

Authorization is enforced server-side in controllers using `authorize` and `policy_scope`.

Navigation links and action buttons are also conditionally displayed according to the current user's permissions.

Unauthorized actions redirect users to the homepage with an error message.

### Listing reports and moderation

Authenticated users can report listings by selecting a reason and providing additional details.

Reports have four possible statuses:

- `pending`: The report has been submitted.
- `reviewed`: A moderator has reviewed the report.
- `dismissed`: A moderator has dismissed the report.
- `action_taken`: A moderator has marked the report as requiring or having received action.

Moderators can access the Reports dashboard to inspect submitted reports and update their statuses.

Updating a report's status does not automatically modify the associated listing.

### Development accounts

The database seed includes accounts for testing authentication and authorization.

| Role | Email | Password |
|------|-------|----------|
| Moderator | `moderador@roomies.cl` | `password123` |
| Property owner | `camila.soto@ejemplo.cl` | `password123` |
| Member | `diego.rojas@ejemplo.cl` | `password123` |

These credentials are intended exclusively for local development and testing.

### Testing and code quality

Run the automated Rails tests:

```bash
bin/rails test
```

Check code formatting and style:

```bash
bin/rubocop
```

Verify Rails autoloading:

```bash
bin/rails zeitwerk:check
```

Check dependencies for known security vulnerabilities:

```bash
bundle exec bundler-audit check --update
```

The test suite includes coverage for authentication functionality and access to protected profile pages.

Pundit policies provide authorization rules for the application's protected resources.

