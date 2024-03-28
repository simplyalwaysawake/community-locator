# frozen_string_literal: true

class Options < ApplicationRecord
  belongs_to :user
  attribute :community_range, default: 20
  validates :community_range, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 100 }
end
