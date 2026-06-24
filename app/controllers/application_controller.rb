# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  # Used by ActiveAdmin (config.authentication_method). Only confirmed admins
  # may reach the admin namespace; everyone else is bounced to the root page.
  def authenticate_admin!
    authenticate_user!
    return if current_user&.admin?

    redirect_to root_path, alert: 'You are not authorized to access this page.' # rubocop:disable Rails/I18nLocaleTexts
  end
end
