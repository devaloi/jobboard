# Build jobboard — Full-Featured Job Board

You are building a **portfolio project** for a Senior AI Engineer's public GitHub. It must be impressive, clean, and production-grade. Read these docs before writing any code:

1. **`R02-rails-job-board.md`** — Complete project spec: architecture, phases, data model, Hotwire patterns, commit plan. This is your primary blueprint. Follow it phase by phase.
2. **`github-portfolio.md`** — Portfolio goals and Definition of Done (Level 1 + Level 2). Understand the quality bar.
3. **`github-portfolio-checklist.md`** — Pre-publish checklist. Every item must pass before you're done.

---

## Instructions

### Read first, build second
Read all three docs completely before writing a single line of code. Understand the multi-role architecture (employer/seeker/admin), the Hotwire real-time patterns (Turbo Frames, Turbo Streams, Stimulus), the application status pipeline, and the namespaced controller structure.

### Follow the phases in order
The project spec has 8 phases. Do them in order:
1. **Scaffold & Auth** — Rails app with Tailwind, Devise user model with roles, responsive layout with navbar and flash messages
2. **Job Listings Core** — Category model, Job model with ActionText, employer CRUD with Turbo Frames, public listings with Pagy pagination
3. **Search & Filters** — Ransack full-text search, advanced filters (job type, category, salary range, location), sort options, Stimulus live search
4. **Applications & Status Tracking** — Application model with status enum, apply flow with Turbo Streams, employer review with status badges, saved jobs
5. **Dashboards & Email** — Employer dashboard (listings + applicants), seeker dashboard (applications + saved), admin dashboard (manage all), ActionMailer notifications
6. **Hotwire Polish & Real-Time** — Turbo Frames for inline editing, Turbo Streams for live application updates, Stimulus controllers for search/salary/flash/toggle
7. **Seeds, Tests & Quality** — Realistic seed data (employers, seekers, jobs, applications), model tests, controller tests, Capybara system tests
8. **Documentation & Final Polish** — README with setup/features/architecture, rubocop clean, index optimization, final smoke test

### Commit frequently
Follow the commit plan in the spec (23 conventional commits). Each commit should be a logical unit. Commit after completing each meaningful piece of work.

### Quality non-negotiables
- **Hotwire-first.** Use Turbo Frames and Turbo Streams for real-time updates. No full page reloads for status changes, inline edits, or search results. This is a Rails 8 app — show modern Rails patterns.
- **Role-based access control.** Employers only see their own jobs and applicants. Seekers only see their own applications. Admins see everything. Enforce in controllers with before_actions, not just UI hiding.
- **ActionText rich text.** Job descriptions use Trix editor with ActionText. Rich formatting, not plain text. This demonstrates Rails' built-in content editing.
- **Application status pipeline.** Statuses (applied → reviewed → interview → offer/rejected) are tracked with timestamps. Status changes trigger email notifications. Use enums with proper validation.
- **Namespaced controllers.** `Employer::`, `Seeker::`, `Admin::` namespaces with separate route scopes. Clean separation of concerns. Not one giant controller.
- **Search that works.** Full-text search + multiple filters (type, category, salary, location) that combine correctly. Filters preserved in URL params. Results update via Turbo Frame.
- **Pagination with Pagy.** Not Kaminari, not will_paginate. Pagy is fastest and most memory-efficient. Use it on all collection views.
- **Responsive Tailwind UI.** Mobile-first. Looks good on phone and desktop. Consistent design: card layouts, status badges, sidebar filters.
- **Stimulus for interactivity.** Debounced search, salary range filter, auto-dismiss flash, mobile toggle. Small, focused controllers.
- **Counter caches.** `applications_count` on jobs, `jobs_count` on categories. No N+1 queries on listing pages.
- **Mailer previews.** ActionMailer with previews in development. Emails have clean HTML layout.
- **Tests cover critical paths.** System tests: full apply flow, employer review flow, search + filter. Model tests: validations, scopes, enums. Controller tests: authorization enforcement.

### What NOT to do
- Don't use a JavaScript framework (React, Vue). This is a Hotwire app. Turbo + Stimulus handle all interactivity.
- Don't use ActiveAdmin or Administrate. Build the admin panel manually — it's simple and shows more skill.
- Don't skip ActionText. Plain text job descriptions look amateur. Rich text is a key feature.
- Don't process search synchronously if it blocks. Wrap search results in a Turbo Frame for async loading.
- Don't forget authorization. Every namespaced controller must verify the user's role. An employer URL accessed by a seeker should redirect, not error.
- Don't commit `config/master.key`, `storage/`, or `db/*.sqlite3` files.
- Don't leave `# TODO` or `# FIXME` comments anywhere.
- Don't skip seeds. The app should look impressive immediately after `db:setup` with realistic data.

---

## GitHub Username

The GitHub username is **devaloi**. For any GitHub URLs, use `github.com/devaloi/jobboard`.

## Start

Read the three docs. Then begin Phase 1 from `R02-rails-job-board.md`.
