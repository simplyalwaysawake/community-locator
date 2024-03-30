# frozen_string_literal: true

class NotifyUsersOfNewUsersJob < ApplicationJob
  queue_as :default

  def perform(users = nil)
    if users
      users.each do |user|
        NewNearbyUserNotification.new(user).send
      end
    else
      User.find_each do |user|
        NewNearbyUserNotification.new(user).send
      end
    end
  end
end
