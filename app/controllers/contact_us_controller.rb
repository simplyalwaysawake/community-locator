# frozen_string_literal: true

class ContactUsController < ApplicationController
  def new; end

  def create
    ContactUsMailer.new_message(
      message_params[:name],
      message_params[:email],
      message_params[:message]
    ).deliver_now

    redirect_to root_path, notice: 'Message sent' # rubocop:disable Rails/I18nLocaleTexts
  end

  def message_params
    params.permit(:name, :email, :message)
  end
end
