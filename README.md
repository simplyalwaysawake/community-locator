# Community Locator

This is a Ruby on Rails app that allows people in the [Simply Always Awake](https://simplyalwaysawake.com/) community who leave near each other to find each other.

You are welcome to fork this repo for your own community. This repo is specific to the [Simply Always Awake deployment](https://communitylocator.simplyalwaysawake.com/), so there are things you will _need_ to tailor to your situation (e.g. references to Simply Always Awake) and others you may _want_ to change (e.g. use different third-party services for geolocation, email, or hosting). If you need any help or have suggestions, please [create a discussion](https://github.com/simplyalwaysawake/community-locator/discussions), [create an issue](https://github.com/simplyalwaysawake/community-locator/issues), or make the change yourself and open a pull request.

# Getting Started

## Prerequisites

Requirements for the software and other tools to build, test and push:

- [ruby 3.2.3](https://www.ruby-lang.org/en/)
- [PostgreSQL](https://www.postgresql.org/)
- [Foreman](https://github.com/ddollar/foreman)

### Third-party services

- [HERE](https://developer.here.com/) – geolocation
- [Mailersend](https://www.mailersend.com/) - email
- [Heroku](https://www.heroku.com/home) - hosting
- [reCAPTCHA](https://www.google.com/recaptcha/about/) - bot protection

## Setup

Run the setup script:

```sh
bin/setup
```

Set an environment variable for the HERE API key. Create a file named **.env.development** in the root of the repo,
and add a line for the key:

```env
HERE_API_KEY=XXXXXXXXXX
RECAPTCHA_SITE_KEY=XXXXXXXXXX
RECAPTCHA_SECRET_KEY=XXXXXXXXXX
```

Contact jeremy@haberman.dev to get the value for the keys.

## Running the app

The app uses a Procfile. In a development environment this takes care of:

- Running the Rails app: `web: bin/rails server`
- Start live CSS rebuilds: `bin/rails tailwindcss:watch`

Run the app:

```sh
$ bin/dev
```

## Running the tests (and rubocop)

[RuboCop](https://github.com/rubocop/rubocop) is used for static code analysis and formatting. To run it:

```sh
rake rubocop
```

To run all the tests (except for system tests):

```sh
rake test
```

To run rubocop and tests:

```sh
rake validate
```

To run all tests, including system tests:

```sh
rake test:all
```

## Contributing

### Testing

Models, controllers, helpers, etc. should have reasonable unit and integration test coverage.

System tests should cover the essential, "happy-path" use cases.

See the [Rails testing guide](https://guides.rubyonrails.org/testing.html) for details.

### Pull requests

The `main` branch is protected, so you will need to use branches and pull requests for getting commits into `main`.

Tests run automatically with each pull request (except for system tests). RuboCop runs too.

After you create a pull request, you will have the option to deploy a Heroku ["review app."](https://devcenter.heroku.com/articles/github-integration-review-apps). This is a great way to test changes in a production-like environment before merging your changes.

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

### Jobs

`NotifyUsersOfNewUsersJob` is a job that runs on a scheduled basis and sends users an email if there
are new people in their area. It uses [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler).

# Libraries

Most notable libraries and services used by the app:

- [Devise](https://github.com/heartcombo/devise) – authentication
- [TailwindCSS](https://github.com/rails/tailwindcss-rails) - styling
- [Mailersend](https://mailersend.com) – email
- [HERE](https://developer.here.com/)
- [recaptcha](https://github.com/ambethia/recaptcha)

# Environments and Deployments

There are two environments where the app is running: staging and production:

- community-locator-staging: https://community-locator-staging-de8254249436.herokuapp.com/
- community-locator-production: https://communitylocator.simplyalwaysawake.com/

When new commits are pushed to the `main` branch, `main` is automatically deployed to the staging environment. This
gives us an opportunity to do some testing before deploying the changes to production.

## Setting up Heroku

1. Contact jeremy@haberman.dev to get access to the applications and pipeline in Heroku.

2. Install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

3. Add git remotes:

```sh
git remote add staging https://git.heroku.com/community-locator-staging.git
git remote add production https://git.heroku.com/community-locator-production.git
```

## Deployments

### Deploying to staging

1. Create a pull request targeting the `main` branch

2. If any new environment variables are needed, add them to staging and production using the Heroku CLI:

```sh
heroku config:set VARIABLE_NAME=XXXXXXXX --remote staging
heroku config:set VARIABLE_NAME=XXXXXXXX --remote production
```

3. When you're ready, merge the pull request into `main`.

The code will be automatically deployed to staging. Database migrations will be automatically applied per our `Procfile`.

### Deploying to production

To promote the code on staging to production using the Heroku CLI, run:

```sh
heroku pipelines:promote -r staging
```

## Setting up the staging and production environments

This only needs to be done once.

https://devcenter.heroku.com/articles/multiple-environments

### Staging

Create app:

```sh
heroku create community-locator-staging --remote staging
```

Set config vars:

```sh
heroku config:set HOST=XXXXXXXX --remote staging
heroku config:set MAILERSEND_SMTP_USERNAME=XXXXXXXX --remote staging
heroku config:set MAILERSEND_SMTP_PASSWORD=XXXXXXXX --remote staging
heroku config:set HERE_API_KEY=XXXXXXXX --remote staging
heroku config:set RECAPTCHA_SITE_KEY=XXXXXXXX --remote staging
heroku config:set RECAPTCHA_SECRET_KEY=XXXXXXXX --remote staging
```

Enable PostgreSQL:

```sh
heroku addons:create heroku-postgresql --remote staging
```

View Heroku PostgreSQL documentation:

```sh
heroku addons:docs heroku-postgresql
```

Enable job scheduler add-on:

```sh
heroku addons:create scheduler:standard -r staging
heroku addons:open scheduler -r staging
```

### Production

Create app:

```sh
heroku create community-locator-production --remote production
```

Set config vars:

```sh
heroku config:set HOST=XXXXXXXX --remote production
heroku config:set MAILERSEND_SMTP_USERNAME=XXXXXXXX --remote production
heroku config:set MAILERSEND_SMTP_PASSWORD=XXXXXXXX --remote production
heroku config:set HERE_API_KEY=XXXXXXXX --remote production
heroku config:set RECAPTCHA_SITE_KEY=XXXXXXXX --remote production
heroku config:set RECAPTCHA_SECRET_KEY=XXXXXXXX --remote production
```

Enable PostgreSQL:

```sh
heroku addons:create heroku-postgresql --remote production
```

Enable job scheduler add-on

```sh
heroku addons:create scheduler:standard -r staging
heroku addons:open scheduler -r staging
```

## Setting up the pipeline

A pipeline with staging and production apps was set up manually using the Heroku UI.

# License

MIT
