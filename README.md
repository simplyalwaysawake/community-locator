# Community Locator

This is Rails app that allows users to find people near them who are interested in waking up.

# Getting Started

## Prerequisites

Requirements for the software and other tools to build, test and push:

- [ruby 3.2.3](https://www.ruby-lang.org/en/)
- [PostgreSQL](https://www.postgresql.org/)
- [Foreman](https://github.com/ddollar/foreman)

## Setup

Run the setup script:

```sh
bin/setup
```

Set an environment variable for the HERE API key. Create a file named **.env.development** in the root of the repo,
and add a line for the key:

```env
HERE_API_KEY="XXXXXXXXXX"
```

Contact jeremy@haberman.dev to get the value for the key.

## Running the app

The app uses a Procfile. In a development environment this takes care of:

- Running the Rails app: `web: bin/rails server`
- Start live CSS rebuilds: `bin/rails tailwindcss:watch`

Run the app:

```sh
$ bin/dev
```

## Running the tests

We do not yet have tests running in any pipelines. Before opening a pull request or merging to main,
make sure to run all the tests:

```sh
bin/rails test:all
```

## Contributing

### Testing

Models, controllers, helpers, etc. should have reasonable unit and integration test coverage.

System tests should cover the essential, "happy-path" use cases.

See the [Rails testing guide](https://guides.rubyonrails.org/testing.html) for details.

### Branches, commits and merges

Avoid committing directly to the `main` branch. Use branches and pull requests for getting commits into `main`.

### Email

Mailersend is used in production, but it is disabled in development. Emails sent in
a local dev environment appear in the log.

If you want to use Mailersend locally,

1. Un-comment-out the section that configures Mailersend in config/environments/development.rb.
2. Add three environment variables to **.env.development**:

- `HOST` (e.g. localhost:3000)
- `MAILERSEND_SMTP_USERNAME`
- `MAILERSEND_SMTP_PASSWORD`

Contact jeremy@haberman.dev for the username and password.

### Geolocation

The app uses the [geocoder](https://github.com/alexreisner/geocoder) gem for geocoding.

See the [Location](app/models/location.rb) model and the [geocoder](config/initializers/geocoder.rb) initializer for how that's wired up.

In a test environment, the lookup service is `:test`, which hard-codes lookup results.

In development and production, it uses [HERE](https://developer.here.com/). You will need to

# Libraries

Most notable libraries and services used by the app:

- [Devise](https://github.com/heartcombo/devise) – authentication
- [TailwindCSS](https://github.com/rails/tailwindcss-rails) - styling
- [Mailersend](https://mailersend.com) – email
- [HERE]()

# Deployment

There is an instance of the app running on [Heroku](https://heroku.com) at https://community-locator.haberman.dev.

The app is automatically deployed when one or more new commits are pushed to the [main branch on GitHub](https://github.com/jeremyhaberman/community-locator).

# License

MIT
