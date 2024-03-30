# frozen_string_literal: true

require 'test_helper'

class NewNearbyUserNotificationTest < ActiveSupport::TestCase
  test 'should notity on one new person' do
    user = users(:john_doe)
    user.update(has_seen_community: true)
    Community.new(user).save_current_nearby_users

    jane_doe = users(:jane_doe)
    jane_doe.update(name: 'Jane Doe')
    jane_doe.create_location(
      city: 'Newark',
      state: 'NJ',
      country: 'USA',
      postal_code: '07101'
    )

    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      NewNearbyUserNotification.new(user).send
      delivery = ActionMailer::Base.deliveries.last
      assert_equal 'New Person in Your Community', delivery.subject
      body = delivery.html_part.body
      assert body.match(/There is a new person in your community./)
      assert body.match(/Jane Doe/)
    end
  end

  test 'should notity on two new people' do # rubocop:disable Metrics/BlockLength
    user = users(:john_doe)
    user.update(has_seen_community: true)
    Community.new(user).save_current_nearby_users

    jane_doe = users(:jane_doe)
    jane_doe.update(name: 'Jane Doe')
    jane_doe.create_location(
      city: 'Newark',
      state: 'NJ',
      country: 'USA',
      postal_code: '07101'
    )

    joe = users(:joe_doe)
    joe.create_location(
      city: 'New York',
      state: 'NJ',
      country: 'USA',
      postal_code: '10001'
    )

    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      NewNearbyUserNotification.new(user).send
      delivery = ActionMailer::Base.deliveries.last
      assert_equal 'New People in Your Community', delivery.subject
      body = delivery.html_part.body
      assert body.match(/There are new people in your community./)
      assert body.match(/Jane Doe/)
      assert body.match(/Joe Doe/)
    end
  end
end
