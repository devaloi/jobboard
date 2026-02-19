# JobBoard

A full-featured job board application with employer/seeker roles, full-text search, Hotwire real-time updates, application tracking, and email notifications — built with Rails 8.1 and Tailwind CSS.

## Tech Stack

| Component  | Choice                         |
|------------|--------------------------------|
| Framework  | Rails 8.1 (full stack)         |
| Ruby       | 3.4                            |
| Database   | SQLite3                        |
| Auth       | Devise                         |
| Rich text  | ActionText + Trix              |
| Real-time  | Turbo Frames + Turbo Streams   |
| JS         | Stimulus                       |
| Search     | Ransack                        |
| Pagination | Pagy                           |
| CSS        | Tailwind CSS                   |
| Email      | ActionMailer                   |
| Testing    | Minitest + Capybara            |
| Linting    | RuboCop (Rails Omakase)        |

## Features

- **Multi-role authentication** — Devise with employer, seeker, and admin roles
- **Rich text job listings** — ActionText editor with formatted descriptions
- **Full-text search** — Ransack-powered search across title, location, company
- **Advanced filters** — Filter by job type, category, salary range, with sort options
- **Application pipeline** — Status tracking (applied → reviewed → interview → offer/reject)
- **Turbo Streams** — Real-time badge updates, instant apply confirmation, live search
- **Stimulus controllers** — Debounced search, auto-dismiss flash, mobile menu toggle
- **Email notifications** — Status change emails with HTML templates and mailer previews
- **Role-based dashboards** — Metrics, recent activity, and quick actions per role
- **Admin panel** — Manage all listings and users without third-party gems
- **Responsive design** — Mobile-first Tailwind CSS with card layouts

## Prerequisites

- Ruby 3.4+
- Rails 8.1+
- SQLite3

## Setup

```bash
git clone https://github.com/devaloi/jobboard.git
cd jobboard
bundle install
bin/rails db:setup    # Creates database, runs migrations, seeds data
bin/dev               # Starts Rails server + Tailwind watcher
```

Visit `http://localhost:3000`

## Demo Credentials

| Role     | Email                      | Password    |
|----------|----------------------------|-------------|
| Admin    | admin@jobboard.test        | password123 |
| Employer | jane@techcorp.test         | password123 |
| Employer | bob@startupxyz.test        | password123 |
| Seeker   | alice@example.test         | password123 |
| Seeker   | charlie@example.test       | password123 |

## Development Commands

```bash
make setup    # Install deps + setup database
make server   # Start dev server (bin/dev)
make test     # Run test suite
make lint     # Run RuboCop
make seed     # Seed database
make console  # Rails console
```

## Architecture

### Role-Based Routing

Routes are namespaced by role for clean separation:

- `/jobs` — Public job listings (search, filter, pagination)
- `/employer/*` — Employer dashboard, job CRUD, application review
- `/seeker/*` — Seeker dashboard, applications, saved jobs
- `/admin/*` — Admin dashboard, user/job management

### Hotwire Patterns

- **Turbo Frames** wrap search results, job cards, and status badges for partial page updates
- **Turbo Streams** broadcast application status changes in real-time and update apply buttons instantly
- **Stimulus** controllers handle debounced search (300ms), flash auto-dismiss (5s), and mobile menu toggle

### Data Model

```
Users (Devise) ──< Jobs ──< JobApplications >── Users (seekers)
                     │              │
                     └── Category   └── Status tracking
                     │
                     └──< SavedJobs >── Users (seekers)
```

## Testing

```bash
bin/rails test                 # Unit + controller tests (72 tests)
bin/rails test:system          # Capybara system tests
```

## License

[MIT](LICENSE)

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
