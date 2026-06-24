# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Also available: :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable, :timeoutable

  has_one :location, dependent: :destroy
  has_one :user_options, dependent: :destroy
  has_one :saved_community, dependent: :destroy, class_name: 'UserCommunity'

  accepts_nested_attributes_for :user_options
  accepts_nested_attributes_for :location,
                                reject_if: lambda { |attrs|
                                  %w[city state country postal_code].all? { |f| attrs[f].blank? }
                                }

  before_validation :sanitize_fields

  def send_devise_notification(notification, *args)
    super.tap { |_| Rails.logger.info("Email sent to #{email}: #{notification}") }
  end

  # Allowlist for ActiveAdmin/Ransack search and filtering.
  def self.ransackable_attributes(_auth_object = nil)
    %w[id email name telegram admin confirmed_at current_sign_in_at created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[location user_options]
  end

  private

  def password_required?
    new_record? || password.present?
  end

  def sanitize_fields
    self.name = name&.strip
    self.telegram = telegram&.strip
    self.telegram = telegram[1..] if telegram&.start_with?('@')
  end
end
