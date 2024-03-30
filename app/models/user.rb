# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Also available: :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable, :timeoutable

  has_one :location, dependent: :destroy
  has_one :user_options, dependent: :destroy

  def password_required?
    new_record? || password.present?
  end
end
