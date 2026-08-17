# frozen_string_literal: true

# Heroku review apps run in this environment (RAILS_ENV is set in app.json).
# It behaves like production, except no real emails are sent.
require_relative 'production'

Rails.application.configure do
  config.action_mailer.delivery_method = :test
end
