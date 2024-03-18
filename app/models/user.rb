# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Also available: :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable,
         :trackable

  has_one :location, dependent: :destroy
end
