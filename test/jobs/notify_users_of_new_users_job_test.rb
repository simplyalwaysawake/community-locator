# frozen_string_literal: true

require 'test_helper'

class NotifyUsersOfNewUsersJobTest < ActiveJob::TestCase
  test 'notify one user' do
    user = users(:john_doe)
    user.user_options.update(notify_on_new_users: true)

    notification = mock('NewNearbyUserNotification')
    NewNearbyUserNotification.expects(:new).with(user).returns(notification)
    notification.expects(:send)

    NotifyUsersOfNewUsersJob.new([users(:john_doe)]).perform_now
  end

  test 'should not notify user if option disabled' do
    user = users(:john_doe)
    user.user_options.update(notify_on_new_users: false)

    NewNearbyUserNotification.expects(:new).never
    NewNearbyUserNotification.any_instance.expects(:send).never

    NotifyUsersOfNewUsersJob.new([users(:john_doe)]).perform_now
  end

  test 'should notify all users' do
    User.find_each do |user|
      if user.user_options
        user.user_options.update(notify_on_new_users: true)
        notification = mock('NewNearbyUserNotification')
        NewNearbyUserNotification.expects(:new).with(user).returns(notification)
        notification.expects(:send)
      end
    end

    NotifyUsersOfNewUsersJob.perform_now
  end
end
