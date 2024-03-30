# frozen_string_literal: true

require 'date'

task send_new_nearby_users_notification: :environment do
  NotifyUsersOfNewUsersJob.perform_now
end
