# frozen_string_literal: true

class LocationsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @location = current_user.location || Location.new
  end

  def create
    @location = Location.new(location_params)
    @location.user = current_user

    if @location.save
      redirect_to root_path, notice: I18n.t('location_saved')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update
    @location = current_user.location
    if @location.update(location_params)
      redirect_to root_path, notice: I18n.t('location_saved')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def location_params
    params.require(:location).permit(:city, :state, :country, :postal_code)
  end
end
