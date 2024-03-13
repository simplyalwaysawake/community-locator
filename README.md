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

Most notable libraries used by the app:

- [Devise](https://github.com/heartcombo/devise) – authentication
- [TailwindCSS](https://github.com/rails/tailwindcss-rails) - styling

# Deployment

There is an instance of the app running on [Heroku](https://heroku.com) at https://community-locator-b0b7e3176ea5.herokuapp.com/.

The app is automatically deployed when one or more new commits are pushed to the [main branch on GitHub](https://github.com/jeremyhaberman/community-locator).

# License

MIT
