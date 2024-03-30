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

    @user.saved_nearby_users.delete_all

    nearby_user_ids = community.map(&:id)
    NearbyUser.insert_all( # rubocop:disable Rails/SkipsModelValidations
      nearby_user_ids.map { |id| { user_id: @user.id, nearby_user_id: id } }
    )
  end

  def new_nearby_users_since_last_save
    return [] unless @user.location

    current_nearby_user_ids = community.map(&:id)
    last_known_nearby_user_ids = NearbyUser.where(user_id: @user.id).map(&:nearby_user_id)

    user_ids = current_nearby_user_ids - last_known_nearby_user_ids
    User.where(id: user_ids)
  end
end
