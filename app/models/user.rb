# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Also available: :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable, :timeoutable

  has_one :location, dependent: :destroy
  has_one :user_options, dependent: :destroy
  has_many :saved_nearby_users, dependent: :destroy, class_name: 'NearbyUser'
  has_one :saved_community, dependent: :destroy, class_name: 'UserCommunity'

  before_validation :sanitize_fields

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
