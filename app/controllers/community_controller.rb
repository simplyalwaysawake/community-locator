# frozen_string_literal: true

class CommunityController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_profile!
  before_action :validate_location!

  def show
    @location = current_user.location
    @community = Community.for(current_user)
  end

  def email_community
    @location = current_user.location
    return unless @location

    @community = Community.for(current_user)
    UserMailer
      .with(user: current_user, community: @community)
      .my_community(current_user, @community)
      .deliver_now
    redirect_to community_path, notice: 'Email sent' # rubocop:disable Rails/I18nLocaleTexts
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
