# frozen_string_literal: true

class Community
  def self.for(user)
    new(user).community
  end

  def initialize(user)
    @user = user
  end

  def community
    if @user.location
      range = @user.user_options&.community_range || UserOptions::DEFAULT_COMMUNITY_RANGE
      User.where(id: @user.location.nearbys(range).map(&:user_id))
    else
      []
    end
  end

  def save_current_nearby_users
    return if @user.location.blank?

    if @user.saved_community
      @user.saved_community.update(nearby_user_ids: community.map(&:id))
    else
      @user.create_saved_community(nearby_user_ids: community.map(&:id))
    end
  end

  def new_nearby_users_since_last_save
    return [] unless @user.location

    current_nearby_user_ids = community.map(&:id)
    last_known_nearby_user_ids = @user.saved_community.nearby_user_ids

    user_ids = current_nearby_user_ids - last_known_nearby_user_ids
    User.where(id: user_ids)
  end
end
