# frozen_string_literal: true

class UserOptions < ApplicationRecord
  DEFAULT_COMMUNITY_RANGE = 20
  MAX_COMMUNITY_RANGE = 100

  belongs_to :user
  attribute :community_range, default: DEFAULT_COMMUNITY_RANGE
  validates :community_range, presence: true,
                              numericality: { only_integer: true, less_than_or_equal_to: MAX_COMMUNITY_RANGE }
end
