# frozen_string_literal: true

namespace :users do
  desc <<~DESC
    Create fake users with geocoded locations.

    Required:
      NUMBER=n         Number of users to create

    Optional (lat/lon bounding rect, defaults to worldwide):
      LAT_MIN=x        Minimum latitude  (default: -90)
      LAT_MAX=x        Maximum latitude  (default:  90)
      LON_MIN=x        Minimum longitude (default: -180)
      LON_MAX=x        Maximum longitude (default:  180)

    Example:
      rake users:create NUMBER=10
      rake users:create NUMBER=5 LAT_MIN=40.5 LAT_MAX=40.9 LON_MIN=-74.1 LON_MAX=-73.7
  DESC
  task create: :environment do
    abort 'This task is only available in development and test environments.' unless Rails.env.local?

    require 'faker'

    number  = ENV.fetch('NUMBER') { abort 'NUMBER is required. Usage: rake users:create NUMBER=10' }.to_i
    lat_min = ENV.fetch('LAT_MIN', '-90').to_f
    lat_max = ENV.fetch('LAT_MAX', '90').to_f
    lon_min = ENV.fetch('LON_MIN', '-180').to_f
    lon_max = ENV.fetch('LON_MAX', '180').to_f

    if lat_min >= lat_max || lon_min >= lon_max
      abort 'Invalid bounding rect: LAT_MIN must be < LAT_MAX and LON_MIN must be < LON_MAX'
    end

    created     = 0
    attempts    = 0
    max_attempts = number * 20

    while created < number && attempts < max_attempts
      attempts += 1

      lat = rand(lat_min..lat_max)
      lon = rand(lon_min..lon_max)

      results = Geocoder.search([lat, lon])
      result  = results.first

      unless result && [result.city, result.state, result.country, result.postal_code].any?(&:present?)
        puts "  No address found for (#{lat.round(4)}, #{lon.round(4)}), skipping..."
        next
      end

      user = User.new(
        email: Faker::Internet.email,
        password: Faker::Internet.password(min_length: 12),
        name: Faker::Name.name,
        confirmed_at: Time.zone.now,
        confirmation_sent_at: Time.zone.now
      )

      user.build_location(
        city: result.city,
        state: result.state,
        country: result.country,
        postal_code: result.postal_code
      )

      user.build_user_options

      if user.save
        created += 1
        puts "  [#{created}/#{number}] #{user.name} <#{user.email}> — #{user.location.address}"
      else
        puts "  Failed (attempt #{attempts}): #{user.errors.full_messages.join(', ')}"
      end
    end

    puts "\nDone. Created #{created}/#{number} users (#{attempts} attempts)."
    abort "Could not create all #{number} users." if created < number
  end
end
