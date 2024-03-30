# frozen_string_literal: true

class CommunityController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_profile!
  before_action :validate_location!
  before_action :validate_options!

  after_action :save_current_nearby_users,
               only: %i[show],
               unless: -> { current_user.has_seen_community? }

  def show
    @location = current_user.location
    @community = Community.for(current_user)
    @range = current_user.user_options.community_range
    render(@community.empty? ? 'empty' : 'show')
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

  def validate_options!
    return unless current_user.user_options.nil?

    redirect_to options_path
  end

  def save_current_nearby_users
    Community.new(current_user).save_current_nearby_users
    current_user.update(has_seen_community: true)
  end
end
