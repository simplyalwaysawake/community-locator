# frozen_string_literal: true

class CommunityController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_profile!
  before_action :validate_location!

  def show
    @location = current_user.location
    @community = User.where(id: @location.nearbys(100).map(&:user_id)) if @location
  end

  private

  def validate_profile!
    return unless current_user.name.nil?

    redirect_to edit_user_registration_path(nil, welcome: true)
  end

  def validate_location!
    return unless current_user.location.nil?

    redirect_to location_path
  end
end
