# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    return unless user_signed_in?

    redirect_to community_path
  end
end
