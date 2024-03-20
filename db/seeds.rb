# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

john_doe = User.where(email: 'john.doe@example.com').first_or_create do |user|
  user.password = 'password123'
  user.name = 'John Doe'
  user.telegram = '@johndoe'
  user.confirmation_sent_at = Time.zone.now
  user.confirmed_at = Time.zone.now

  user.location = Location.new(
  {
    city: 'Minneapolis',
    state: 'MN',
    country: 'United States',
    postal_code: '55401'
  }
)
end

john_doe.save!
