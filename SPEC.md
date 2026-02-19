# R02: jobboard — Full-Featured Job Board

**Catalog ID:** R02 | **Size:** L | **Language:** Ruby / Rails
**Repo name:** `jobboard`
**One-liner:** A polished job board with employer/seeker roles, full-text search, Hotwire real-time updates, application tracking, and email notifications — built with Rails 8.1 and Tailwind CSS.

---

## Why This Stands Out

- **Full Hotwire stack** — Turbo Frames for inline editing, Turbo Streams for real-time updates, Stimulus for interactive UI — no React, no SPA, pure Rails
- **Multi-role authentication** — Devise with employer and job seeker roles, scoped dashboards, and role-based access control
- **Rich text job listings** — ActionText with Trix editor, image attachments via ActiveStorage
- **Advanced search** — full-text search with pg_search or Ransack, filters by location, salary range, job type, and category
- **Application pipeline** — status tracking (applied → reviewed → interview → offer/reject) with state machine transitions
- **Email notifications** — ActionMailer triggered on application status changes, with mailer previews
- **Responsive Tailwind UI** — mobile-first design, sidebar navigation, card layouts, consistent design system
- **Admin panel** — manage all listings, users, and flagged content without a gem like ActiveAdmin
- **System tests** — Capybara tests for critical user flows, plus model and controller tests
- **Production patterns** — pagination (Pagy), counter caches, database indexes, N+1 query prevention with `includes`

---

## Architecture

```
jobboard/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── home_controller.rb              # Landing page with featured jobs
│   │   ├── jobs_controller.rb              # Public job listings + CRUD for employers
│   │   ├── applications_controller.rb      # Job seekers apply, employers review
│   │   ├── dashboards_controller.rb        # Role-based dashboard routing
│   │   ├── employer/
│   │   │   ├── jobs_controller.rb          # Employer's own job CRUD
│   │   │   ├── applications_controller.rb  # Review applicants, change status
│   │   │   └── dashboard_controller.rb     # Employer metrics + listings
│   │   ├── seeker/
│   │   │   ├── applications_controller.rb  # Seeker's applied jobs
│   │   │   └── dashboard_controller.rb     # Seeker metrics + saved jobs
│   │   └── admin/
│   │       ├── dashboard_controller.rb     # Admin overview
│   │       ├── jobs_controller.rb          # Manage all listings
│   │       └── users_controller.rb         # Manage all users
│   ├── models/
│   │   ├── user.rb                         # Devise user with role enum
│   │   ├── job.rb                          # Job listing with ActionText body
│   │   ├── application.rb                  # Join model: user applies to job
│   │   ├── category.rb                     # Job categories (Engineering, Design, etc.)
│   │   └── saved_job.rb                    # Bookmarked jobs for seekers
│   ├── views/
│   │   ├── layouts/
│   │   │   └── application.html.erb        # Tailwind layout with responsive nav
│   │   ├── home/
│   │   │   └── index.html.erb              # Landing page
│   │   ├── jobs/
│   │   │   ├── index.html.erb              # Job listings with search/filters
│   │   │   ├── show.html.erb               # Job detail with apply button
│   │   │   ├── _job.html.erb               # Turbo Frame partial
│   │   │   ├── _form.html.erb              # ActionText form
│   │   │   └── _search.html.erb            # Search + filter sidebar
│   │   ├── applications/
│   │   │   ├── _application.html.erb       # Turbo Stream partial
│   │   │   └── _status_badge.html.erb      # Status pill component
│   │   ├── employer/
│   │   │   └── dashboard/
│   │   │       └── show.html.erb           # Employer dashboard
│   │   ├── seeker/
│   │   │   └── dashboard/
│   │   │       └── show.html.erb           # Seeker dashboard
│   │   └── admin/
│   │       └── dashboard/
│   │           └── show.html.erb           # Admin dashboard
│   ├── javascript/
│   │   └── controllers/                    # Stimulus controllers
│   │       ├── search_controller.js        # Live search with debounce
│   │       ├── salary_range_controller.js  # Salary range slider
│   │       ├── flash_controller.js         # Auto-dismiss flash messages
│   │       └── toggle_controller.js        # Mobile menu, dropdowns
│   ├── mailers/
│   │   └── application_mailer.rb           # Status change notifications
│   ├── helpers/
│   │   └── application_helper.rb           # Badge helpers, formatting
│   └── components/                         # ViewComponent or partials
│       ├── _navbar.html.erb
│       ├── _footer.html.erb
│       └── _pagination.html.erb
├── config/
│   ├── routes.rb                           # Namespaced routes (employer/, seeker/, admin/)
│   ├── database.yml
│   └── initializers/
│       ├── devise.rb
│       └── pagy.rb
├── db/
│   ├── migrate/
│   ├── seeds.rb                            # Realistic demo data
│   └── schema.rb
├── test/
│   ├── models/
│   ├── controllers/
│   ├── system/                             # Capybara system tests
│   ├── mailers/
│   ├── fixtures/
│   └── test_helper.rb
├── Gemfile
├── Makefile
├── Procfile.dev
├── .rubocop.yml
├── .gitignore
├── LICENSE
└── README.md
```

---

## Data Model

```
users
  id, email, password (Devise), role (enum: employer/seeker/admin),
  company_name (nullable, employers), full_name, bio (text, nullable),
  created_at, updated_at

jobs
  id, user_id (employer), title, location, salary_min (integer),
  salary_max (integer), job_type (enum: full_time/part_time/contract/remote),
  category_id, status (enum: draft/published/closed/archived),
  body (ActionText rich text), expires_at (date, nullable),
  applications_count (counter cache), created_at, updated_at

categories
  id, name, slug, jobs_count (counter cache), created_at

applications
  id, job_id, user_id (seeker), cover_letter (text),
  status (enum: applied/reviewed/interview/offer/rejected),
  status_changed_at (datetime), created_at, updated_at

saved_jobs
  id, user_id (seeker), job_id, created_at
  (unique index on [user_id, job_id])
```

---

## Routes Overview

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/` | Landing page with featured/recent jobs |
| `GET` | `/jobs` | Public job listings (search, filters, pagination) |
| `GET` | `/jobs/:id` | Job detail page |
| `POST` | `/jobs/:id/apply` | Submit application (seekers) |
| `POST` | `/jobs/:id/save` | Save/bookmark job (seekers) |
| `DELETE` | `/jobs/:id/unsave` | Remove saved job |
| — | **Employer namespace** | — |
| `GET` | `/employer/dashboard` | Employer dashboard |
| `GET` | `/employer/jobs` | Employer's own listings |
| `GET/POST` | `/employer/jobs/new` | Create new listing |
| `GET/PATCH` | `/employer/jobs/:id/edit` | Edit listing (Turbo Frame) |
| `DELETE` | `/employer/jobs/:id` | Archive listing |
| `GET` | `/employer/jobs/:id/applications` | Applicants for a listing |
| `PATCH` | `/employer/applications/:id/status` | Update application status (Turbo Stream) |
| — | **Seeker namespace** | — |
| `GET` | `/seeker/dashboard` | Seeker dashboard |
| `GET` | `/seeker/applications` | Seeker's applied jobs |
| `GET` | `/seeker/saved` | Seeker's bookmarked jobs |
| — | **Admin namespace** | — |
| `GET` | `/admin/dashboard` | Admin overview (counts, recent activity) |
| `GET` | `/admin/jobs` | All jobs (manage, flag, remove) |
| `GET` | `/admin/users` | All users |
| `DELETE` | `/admin/jobs/:id` | Force-remove listing |

### Query Parameters for `GET /jobs`

| Param | Description |
|-------|-------------|
| `q` | Full-text search (title, company, body) |
| `location` | Filter by location |
| `job_type` | Filter by type (full_time, part_time, contract, remote) |
| `category` | Filter by category slug |
| `salary_min` | Minimum salary filter |
| `sort` | Sort field (newest, salary_high, salary_low) |
| `page` | Page number (Pagy) |

---

## Tech Stack

| Component | Choice |
|-----------|--------|
| Framework | Rails 8.1 (full stack) |
| Ruby | 3.3 |
| Database | SQLite3 |
| Auth | Devise |
| Rich text | ActionText + Trix |
| Real-time | Turbo Frames + Turbo Streams |
| JS | Stimulus |
| Search | Ransack (or pg_search) |
| Pagination | Pagy |
| CSS | Tailwind CSS |
| Email | ActionMailer |
| Testing | Minitest + Capybara |
| Linting | RuboCop + rubocop-rails |

---

## Phased Build Plan

### Phase 1: Scaffold & Auth

**1.1 — Rails project setup**
- `rails new jobboard --database=sqlite3 --css=tailwind`
- Add gems: `devise`, `pagy`, `ransack`, `rubocop`, `rubocop-rails`
- Configure Tailwind, import maps, Turbo + Stimulus
- Create `Makefile` with: `setup`, `test`, `lint`, `server`, `db:reset`, `seed`, `console`
- Create `Procfile.dev` for `bin/dev` (Rails + Tailwind watcher)

**1.2 — User model + Devise**
- Install Devise, generate User model
- Add `role` enum: `employer`, `seeker`, `admin`
- Add `company_name`, `full_name`, `bio` fields
- Add role-based helper methods: `employer?`, `seeker?`, `admin?`
- Configure Devise views with Tailwind styling
- Create seeds: 1 admin, 3 employers, 5 seekers

**1.3 — Layout & navigation**
- Application layout with responsive Tailwind navbar
- Role-aware navigation (show different links per role)
- Flash message component with Stimulus auto-dismiss
- Footer component
- Mobile hamburger menu with Stimulus toggle

### Phase 2: Job Listings Core

**2.1 — Category model**
- Generate Category with `name`, `slug`, `jobs_count` (counter cache)
- Seed 8-10 categories: Engineering, Design, Marketing, Sales, etc.
- Validations: name presence, slug uniqueness

**2.2 — Job model + ActionText**
- Generate Job model with all fields (title, location, salary_min, salary_max, job_type, status, expires_at)
- Install ActionText for rich text `body`
- Add associations: belongs_to user, belongs_to category, has_rich_text body
- Add enums: `job_type` (full_time, part_time, contract, remote), `status` (draft, published, closed, archived)
- Validations: title, location required; salary_min ≤ salary_max; status transitions
- Scopes: `published`, `active` (published + not expired), `by_type`, `by_category`, `recent`
- Counter cache on category

**2.3 — Employer job CRUD**
- Namespaced `Employer::JobsController` — index, new, create, edit, update, destroy
- Only employer's own jobs (scope to `current_user.jobs`)
- Form with ActionText body, category select, salary range, job type radio buttons
- Turbo Frame for inline edit on employer dashboard
- Flash messages via Turbo Stream

**2.4 — Public job listings**
- `JobsController#index` — paginated, filterable public listing
- `JobsController#show` — job detail with formatted rich text body
- Search + filter sidebar partial
- Card-based job listing layout with Tailwind
- Pagination with Pagy

### Phase 3: Search & Filters

**3.1 — Full-text search with Ransack**
- Configure Ransack on Job model
- Search across title, location, and company_name
- Search form with Turbo Frame for live results
- Stimulus search controller with debounced input

**3.2 — Advanced filters**
- Filter by: job_type, category, location, salary range
- Combine filters with search (all additive)
- Salary range slider with Stimulus controller
- Filter state preserved in URL params
- "Clear all filters" button

**3.3 — Sort options**
- Sort by: newest (default), salary high→low, salary low→high
- Sort dropdown in listing header
- Turbo Frame wrapping results for instant re-sort

### Phase 4: Applications & Status Tracking

**4.1 — Application model**
- Generate Application: job_id, user_id, cover_letter, status, status_changed_at
- Status enum: `applied`, `reviewed`, `interview`, `offer`, `rejected`
- Validations: one application per user per job (unique index)
- Associations: belongs_to job, belongs_to user (seeker)
- Scopes: `by_status`, `recent`, `for_employer` (applications on employer's jobs)

**4.2 — Applying to jobs**
- Apply button on job show page (seekers only)
- Cover letter text area (optional)
- Turbo Stream to replace apply button with "Applied ✓" after submission
- Prevent duplicate applications (validation + UI state)

**4.3 — Employer application review**
- `Employer::ApplicationsController` — list applicants per job, update status
- Status update via dropdown (Turbo Stream for instant badge update)
- Status badge component (color-coded pills: blue/yellow/green/red)
- Filter applicants by status within a job listing
- Record `status_changed_at` on each transition

**4.4 — Saved jobs**
- SavedJob model (user_id, job_id, unique index)
- Save/unsave toggle button with Turbo Stream
- `Seeker::SavedController` — list saved jobs

### Phase 5: Dashboards & Email

**5.1 — Employer dashboard**
- Summary cards: total listings, active listings, total applicants, new applicants (this week)
- Recent applications table with status badges
- Quick links to manage each listing
- Chart-ready data (counts by status — display as simple table/list)

**5.2 — Seeker dashboard**
- Summary cards: applications sent, interviews scheduled, offers received
- Applied jobs list with current status
- Saved jobs list
- Suggested jobs (same category as applied jobs)

**5.3 — Admin dashboard**
- Overview: total users, total jobs, total applications
- Recent jobs table (all, with employer info)
- Recent users table
- Admin::JobsController — view/remove any listing
- Admin::UsersController — view all users

**5.4 — Email notifications**
- ApplicationMailer: `status_changed(application)` — notify seeker when status changes
- Mailer layout with Tailwind-style inline CSS
- Mailer previews for development
- Trigger email on status update in ApplicationsController

### Phase 6: Hotwire Polish & Real-Time

**6.1 — Turbo Frames**
- Job card as Turbo Frame (inline preview → detail expand)
- Employer job edit as Turbo Frame (edit in place on dashboard)
- Application status update as Turbo Frame (instant badge swap)
- Search results wrapped in Turbo Frame (filter without full reload)

**6.2 — Turbo Streams**
- New application: stream new row to employer's application list
- Status change: stream updated badge to all viewing the same job
- Flash messages via Turbo Stream append
- Job publish: stream new job to public listing (if on page)

**6.3 — Stimulus controllers**
- `search_controller.js` — debounced live search (300ms delay)
- `salary_range_controller.js` — dual-handle salary range filter
- `flash_controller.js` — auto-dismiss after 5 seconds with fade
- `toggle_controller.js` — mobile menu, filter sidebar collapse

### Phase 7: Seeds, Tests & Quality

**7.1 — Realistic seed data**
- 3 employer accounts with 5-8 jobs each (varied categories, statuses)
- 5 seeker accounts with 2-5 applications each (varied statuses)
- 1 admin account
- Realistic job titles, descriptions, company names, locations, salary ranges
- Use ActionText for rich job descriptions (formatted paragraphs, lists)

**7.2 — Model tests**
- User: role validation, helper methods, associations
- Job: validations, scopes, enum behaviors, counter cache
- Application: uniqueness, status transitions, associations
- Category: slug generation, counter cache

**7.3 — Controller tests**
- Jobs: public index/show, employer CRUD (authorization), search + filter
- Applications: apply (seeker only), status update (employer only), duplicate prevention
- Dashboards: role-based access (employer can't see seeker dashboard)
- Admin: admin-only access enforcement

**7.4 — System tests (Capybara)**
- Full apply flow: seeker searches → finds job → applies → sees in dashboard
- Employer flow: create job → publish → review applicant → change status
- Search and filter: enter query → apply filters → verify results
- Auth: sign up → sign in → role-specific redirect

### Phase 8: Documentation & Final Polish

**8.1 — README.md**
- Project description with screenshots (placeholder locations)
- Tech stack overview
- Setup instructions: clone, bundle, db:setup, bin/dev
- Demo credentials (from seeds)
- Features overview with section links
- Architecture notes (Hotwire patterns, role-based routing)
- Development commands (make targets)

**8.2 — Code quality pass**
- `bundle exec rubocop --autocorrect` — clean pass
- Remove unused routes, dead code, empty files
- Ensure all database indexes are in place (foreign keys, unique constraints, search columns)
- N+1 prevention: `includes` on all collection queries
- Verify `bin/setup` works from clean clone

**8.3 — Final smoke test**
- `bin/rails db:setup` from scratch
- `bin/dev` starts cleanly
- Full test suite green: `bin/rails test` + `bin/rails test:system`
- All seeded accounts can log in and see correct dashboards
- Search, filter, apply, status change all work end to end

---

## Commit Plan

1. `chore: scaffold Rails app with Tailwind and Devise`
2. `feat: add User model with roles and Devise auth`
3. `feat: add responsive layout with Tailwind navbar and flash messages`
4. `feat: add Category model with seeds`
5. `feat: add Job model with ActionText and enums`
6. `feat: add employer job CRUD with Turbo Frame forms`
7. `feat: add public job listings with pagination`
8. `feat: add search and filters with Ransack`
9. `feat: add Stimulus controllers for live search and salary range`
10. `feat: add Application model with status tracking`
11. `feat: add apply flow with Turbo Stream updates`
12. `feat: add employer application review with status badges`
13. `feat: add saved jobs for seekers`
14. `feat: add employer and seeker dashboards`
15. `feat: add admin dashboard with job and user management`
16. `feat: add email notifications for application status changes`
17. `feat: add Turbo Stream real-time updates for applications`
18. `test: add model and controller tests`
19. `test: add Capybara system tests for critical flows`
20. `feat: add realistic seed data`
21. `refactor: N+1 fixes, index optimization, code cleanup`
22. `docs: add README with setup, features, and architecture`
23. `chore: final rubocop pass and polish`
