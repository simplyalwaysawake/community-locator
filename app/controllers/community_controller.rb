# frozen_string_literal: true

class CommunityController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_location!

  def show
    @location = current_user.location
    @community = User.where(id: @location.nearbys(100).map(&:user_id)) if @location
  end

  private

  def validate_location!
    return unless current_user.location.nil?

    redirect_to location_path
  end
end
