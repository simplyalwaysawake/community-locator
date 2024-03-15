class HomeController < ApplicationController
  def index
    if current_user && current_user.location.nil?
      redirect_to location_path
    end
  end
end
