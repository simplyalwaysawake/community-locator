# frozen_string_literal: true

class UserCommunity < ApplicationRecord
  belongs_to :user

  def nearby_user_ids
    super.map(&:to_i) || []
  end
end
