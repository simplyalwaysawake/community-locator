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
end
