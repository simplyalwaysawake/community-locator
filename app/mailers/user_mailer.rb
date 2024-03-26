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
end
