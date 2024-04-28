# frozen_string_literal: true

class Location < ApplicationRecord
  belongs_to :user

  before_validation :sanitize_fields

  validate :user_does_not_already_have_a_location, on: :create
  validate :at_least_one_field_present, on: :create

  geocoded_by :address
  after_validation :geocode

  before_save :verify_coordinates

  def address
    address = [city, state, country].reject { |p| p.to_s.empty? }.join(', ')
    address += " #{postal_code}" if postal_code.present?
    address
  end

  def clear_coordinates
    self.latitude = nil
    self.longitude = nil
  end

  def coordinates?
    latitude.present? && longitude.present?
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

  def at_least_one_field_present
    return false unless %w[city state country postal_code].all? { |attr| self[attr].blank? }

    errors.add :base, 'At least one field must have a value'
  end

  def verify_coordinates
    return if latitude.present? && longitude.present?

    errors.add(:base, I18n.t('location_not_found'))
    throw(:abort)
  end
end
