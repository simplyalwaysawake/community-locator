# frozen_string_literal: true

class NotifyUsersOfNewUsersJob < ApplicationJob
  queue_as :default

  def perform(users = nil)
    if users
      users.each do |user|
        try_send_notification(user)
      end
    else
      User.find_each do |user|
        try_send_notification(user)
      end
    end
  end

  def try_send_notification(user)
    NewNearbyUserNotification.new(user).send
  rescue StandardError => e
    Rails.logger.error("Error sending notification to user #{user.id}: #{e.message}")
  end
end
