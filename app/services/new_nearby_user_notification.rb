# frozen_string_literal: true

class NewNearbyUserNotification
  def initialize(user)
    @user = user
    @community = Community.new(@user)
  end

  def send
    new_nearby_users = @community.new_nearby_users_since_last_save

    return if new_nearby_users.empty?

    UserMailer
      .new_nearby_users(@user, new_nearby_users)
      .deliver_now

    @community.save_current_nearby_users
  end
end
