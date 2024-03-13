# Community Locator

This is Rails app that allows users to find people near them who are interested in waking up.

# Getting Started

## Prerequisites

Requirements for the software and other tools to build, test and push:

- [ruby 3.2.3](https://www.ruby-lang.org/en/)
- [SQLite 3.8.0+](https://www.sqlite.org/)
- [Foreman](https://github.com/ddollar/foreman)

## Setup

Run the setup script:

```sh
bin/setup
```

### Configure Mailersend

Three environment variables need to be set for Mailersend to work:

- `HOST` (e.g. localhost:3000)
- `MAILERSEND_SMTP_USERNAME`
- `MAILERSEND_SMTP_PASSWORD`

The username and password are too sensitive to store in the repo. Contact jeremy@haberman.dev for details.

## Running the app

The app uses a Procfile. In a development environment this takes care of:

- Running the Rails app: `web: bin/rails server`
- Start live CSS rebuilds: `bin/rails tailwindcss:watch`

Run the app:

```sh
$ bin/dev
```

## Running the tests

```sh
bin/rails test
```

# Libraries

Most notable libraries and services used by the app:

- [Devise](https://github.com/heartcombo/devise) – authentication
- [TailwindCSS](https://github.com/rails/tailwindcss-rails) - styling
- [Mailersend](https://mailersend.com) – email

# Deployment

There is an instance of the app running on [Heroku](https://heroku.com) at https://community-locator.haberman.dev.

The app is automatically deployed when one or more new commits are pushed to the [main branch on GitHub](https://github.com/jeremyhaberman/community-locator).

# License

MIT
