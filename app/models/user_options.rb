# frozen_string_literal: true

class UserOptions < ApplicationRecord
  DEFAULT_COMMUNITY_RANGE = 20
  MAX_COMMUNITY_RANGE = 200

  belongs_to :user
  attribute :community_range, default: 20
  validates :community_range, presence: true,
                              numericality: { only_integer: true, less_than_or_equal_to: 200 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id community_range notify_on_new_users created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user]
  end
end
