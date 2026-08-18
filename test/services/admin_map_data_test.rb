# frozen_string_literal: true

require 'test_helper'

class AdminMapDataTest < ActiveSupport::TestCase
  test 'returns only users with complete coordinates and the fields needed by the map' do
    payload = AdminMapData.call
    mapped_users = payload.fetch(:users)
    mapped_location_count = Location
                            .where.not(latitude: nil)
                            .where.not(longitude: nil)
                            .count

    assert_equal User.count, payload.fetch(:total_count)
    assert_equal mapped_location_count, mapped_users.size
    assert_equal(
      %i[email id latitude location longitude name telegram],
      mapped_users.first.keys.sort
    )

    john = mapped_users.find { |user| user.fetch(:id) == users(:john_doe).id }
    assert_equal 'John Doe', john.fetch(:name)
    assert_equal 'john.doe@example.com', john.fetch(:email)
    assert_equal 'johndoe', john.fetch(:telegram)
    assert_equal 'New York, NY', john.fetch(:location)
    assert_in_delta 40.6973709, john.fetch(:latitude)
    assert_in_delta(-74.1444873, john.fetch(:longitude))

    assert_not(mapped_users.any? { |user| user.fetch(:id) == users(:jane_doe).id })
  end

  test 'uses the email prefix when a mapped user has no name' do
    mapped_user = AdminMapData.call.fetch(:users).find do |user|
      user.fetch(:id) == users(:user3).id
    end

    assert_equal 'user3', mapped_user.fetch(:name)
  end

  test 'excludes a location when either coordinate is missing' do
    # Deliberately create a row that model validations would normally reject.
    locations(:new_york).update_column(:longitude, nil) # rubocop:disable Rails/SkipsModelValidations

    mapped_user_ids = AdminMapData.call.fetch(:users).pluck(:id)

    assert_not_includes mapped_user_ids, users(:john_doe).id
  end
end
