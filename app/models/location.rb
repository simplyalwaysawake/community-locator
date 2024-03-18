# frozen_string_literal: true

class Location < ApplicationRecord
  belongs_to :user
  before_validation :sanitize_fields
  validate :user_does_not_already_have_a_location, on: :create
  geocoded_by :address
  after_validation :geocode

  def address
    address = [city, state, country].reject { |p| p.to_s.empty? }.join(', ')
    address += " #{postal_code}" if postal_code.present?
    address
  end

  private

  def sanitize_fields
    self.city = city&.strip
    self.state = state&.strip
    self.country = country&.strip
    self.postal_code = postal_code&.strip
  end

  def user_does_not_already_have_a_location
    return unless Location.where(user:).count >= 1

    errors.add(:base, 'User already has a location')
  end
end
