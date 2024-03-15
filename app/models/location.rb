class Location < ApplicationRecord
  belongs_to :user
  before_validation :sanitize_fields
  validate :user_does_not_already_have_a_location, on: :create

  def address
    address = [city, state, country].reject { |p| p.to_s.empty? }.join(", ")
    address += " #{postal_code}" if postal_code.present?
    address
  end

  private

  def sanitize_fields
    self.city = city.strip if city.present?
    self.state = state.strip if state.present?
    self.country = country.strip if country.present?
    self.postal_code = postal_code.strip if postal_code.present?
  end

  def user_does_not_already_have_a_location
    if Location.where(user: user).count >= 1
      errors.add(:base, "User already has a location")
    end
  end
end
