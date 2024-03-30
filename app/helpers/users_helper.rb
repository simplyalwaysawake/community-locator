# frozen_string_literal: true

module UsersHelper
  def display_name(user)
    user.name.presence || user.email.split('@').first
  end

  def display_telegram(user)
    user.telegram ? "@#{user.telegram}" : ''
  end
end
