# frozen_string_literal: true

require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  test '#for should return only one user' do
    user = users(:john_doe)
    community = Community.for(user)
    assert_equal 1, community.count
    assert_equal users(:user3).id, community.first.id
  end

  test 'should return empty array if user has no location' do
    user = users(:jane_doe)
    community = Community.for(user)
    assert community.empty?
  end

  test 'should save nearby users' do
    user = users(:john_doe)
    Community.new(user).save_current_nearby_users

    user.reload
    nearby_user_ids = user.saved_community.nearby_user_ids
    assert_equal 1, nearby_user_ids.count
    assert_equal users(:user3).id, nearby_user_ids.first
  end

  test 'should detect added community user' do
    user = users(:john_doe)
    Community.new(user).save_current_nearby_users

    jane_doe = users(:jane_doe)
    jane_doe.create_location(
      city: 'Newark',
      state: 'NJ',
      country: 'USA',
      postal_code: '07101'
    )

    assert_equal [jane_doe], Community.new(user).new_nearby_users_since_last_save
  end
end
