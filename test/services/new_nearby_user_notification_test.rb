# frozen_string_literal: true

require 'test_helper'

class NewNearbyUserNotificationTest < ActiveSupport::TestCase
  test 'should notity' do
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
      body = ActionMailer::Base.deliveries.last.html_part.body
      assert body.match(/There are new people in your community./)
      assert body.match(/Jane Doe/)
    end
  end
end
