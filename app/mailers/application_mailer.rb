# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Simply Always Awake Community Locator <communitylocator@simplyalwaysawake.com>'
  layout 'mailer'
end
