# frozen_string_literal: true

class UserMailer < ApplicationMailer
  helper LocationsHelper

  def my_community(user, community)
    @user = user
    @community = community

    bootstrap_mail(
      to: user.email,
      subject: 'Your Simply Always Awake Community'
    )
  end

  def new_nearby_users(user, new_nearby_users)
    @user = user
    @new_nearby_users = new_nearby_users

    bootstrap_mail(
      to: user.email,
      subject: 'New People in Your Community'
    )
  end
end
