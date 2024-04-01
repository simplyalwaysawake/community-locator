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

  user.user_options = UserOptions.new(
    {
      community_range: 50,
      notify_on_new_users: true
    }
  )
end

john_doe.save!

# Jim Anderson

User.where(email: 'jim.anderson@example.com').first_or_create do |user|
  user.password = 'password123'
  user.name = 'Jim Anderson'
  user.telegram = '@jimanderson'
  user.confirmation_sent_at = Time.zone.now
  user.confirmed_at = Time.zone.now

  user.location = Location.new(
    {
      city: 'Edina',
      state: 'MN',
      country: 'United States',
      postal_code: '55439'
    }
  )

  user.user_options = UserOptions.new(
    {
      community_range: 50,
      notify_on_new_users: true
    }
  )

  user.save!
end

User.where(email: 'tom.thompson@example.com').first_or_create do |user|
  user.password = 'password123'
  user.name = 'Tom Thompson'
  user.telegram = '@tomthompson'
  user.confirmation_sent_at = Time.zone.now
  user.confirmed_at = Time.zone.now

  user.location = Location.new(
    {
      city: 'St. Paul',
      state: 'MN',
      country: 'United States'
    }
  )

  user.user_options = UserOptions.new(
    {
      community_range: 50,
      notify_on_new_users: true
    }
  )

  user.save!
end
