# frozen_string_literal: true

class Options < ApplicationRecord
  MAX_COMMUNITY_RANGE = 100

  belongs_to :user
  attribute :community_range, default: 20
  validates :community_range, presence: true,
                              numericality: { only_integer: true, less_than_or_equal_to: Options::MAX_COMMUNITY_RANGE }
end
