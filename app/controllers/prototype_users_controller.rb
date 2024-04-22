# frozen_string_literal: true

class PrototypeUsersController < ApplicationController
  def unsubscribe
    prototype_user_id = Rails.application.message_verifier(:unsubscribe).verify(params[:token])
    prototype_user = PrototypeUser.find(prototype_user_id)

    @message = if prototype_user.update(unsubscribed_at: Time.zone.now)
                 'You have unsubscribed from announcements.'
               else
                 'Error unsubscribing. Please contact communitylocator@simplyalwaysawake.com.'
               end
  rescue StandardError
    @message = 'Error unsubscribing. Please contact communitylocator@simplyalwaysawake.com.'
  end
end
