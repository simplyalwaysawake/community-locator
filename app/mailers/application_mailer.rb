# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Simply Always Awake Community Locator <communitylocator@simplyalwaysawake.com>'
  layout 'bootstrap-mailer'

  after_deliver :log_email

  private

  def log_email
    Rails.logger.info("Email sent to #{mail.to} with subject '#{mail.subject}'")
  end
end
