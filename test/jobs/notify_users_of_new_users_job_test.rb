# frozen_string_literal: true

require 'test_helper'

class NotifyUsersOfNewUsersJobTest < ActiveJob::TestCase
  test 'notify one user' do
    user = users(:john_doe)

    notification = mock('NewNearbyUserNotification')
    NewNearbyUserNotification.expects(:new).with(user).returns(notification)
    notification.expects(:send)

    NotifyUsersOfNewUsersJob.new([users(:john_doe)]).perform_now
  end

  test 'should notify all users' do
    User.find_each do |user|
      notification = mock('NewNearbyUserNotification')
      NewNearbyUserNotification.expects(:new).with(user).returns(notification)
      notification.expects(:send)
    end

    NotifyUsersOfNewUsersJob.perform_now
  end
end
