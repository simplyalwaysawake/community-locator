class HomeController < ApplicationController
  def show
    if user_signed_in?
      redirect_to community_path
    end
  end
end
