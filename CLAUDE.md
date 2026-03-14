# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

**Development:**
- `bin/dev` — Start Rails server + Tailwind CSS watch (Foreman)
- `bin/setup` — Install deps, prepare database, clear logs

**Testing:**
- `bin/rails test` — Run all tests except system tests
- `bin/rails test test/models/user_test.rb` — Run a single test file
- `bin/rails test test/models/user_test.rb:42` — Run a specific test by line number
- `rake test:all` — Run all tests including system tests
- `rake validate` — RuboCop + tests (no system tests); used in CI

**Linting:**
- `rake rubocop` — Run RuboCop
- Lefthook runs RuboCop auto-fix on staged Ruby files as a pre-commit hook

## Architecture

**Purpose:** Users register, enter a location (geocoded via HERE API), and can view/email nearby community members within a configurable radius.

**Key models:**
- `User` — Devise auth (confirmable, lockable, trackable); has one `Location` and one `UserOptions`
- `Location` — City/state/country/postal_code + geocoded lat/long; uses Geocoder gem with HERE API
- `UserOptions` — Preferences: `community_range` (default 20 miles, max 200), `notify_on_new_users`
- `UserCommunity` — Caches `nearby_user_ids` array for change-detection by the notification job

**Community discovery flow:**
1. User submits address → `Location` geocodes via HERE API → stores lat/long
2. `Community` service calls `Location.nearbys(range_in_miles)` to find nearby users
3. `NotifyUsersOfNewUsersJob` (Heroku Scheduler) compares current nearby users to `UserCommunity` snapshot and emails users about new neighbors via `UserMailer`

**Key services/jobs:**
- `app/services/community.rb` — Finds nearby users, saves snapshot, checks for new users since last check
- `app/jobs/notify_users_of_new_users_job.rb` — Scheduled job for new-neighbor notifications
- `app/mailers/user_mailer.rb` — Sends community and new-neighbor emails (bootstrap-email gem)

**Auth:** Custom `UsersRegistrationsController` extends Devise; email confirmation required.

**Testing:** Minitest with fixtures. Geocoding is stubbed in tests (hardcoded NYC coords). System tests use Capybara + Selenium.

**Deployment:** Heroku (staging auto-deploys from main). Migrations run on release via Procfile.

**Required env vars:** `HERE_API_KEY`, `RECAPTCHA_SITE_KEY`, `RECAPTCHA_SECRET_KEY`
