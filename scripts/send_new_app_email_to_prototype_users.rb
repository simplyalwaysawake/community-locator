# frozen_string_literal: true

# Usage: rails runner scripts/send_new_app_email_to_prototype_users.rb [test_email_address]
# The optional 'test_email_address' argument will send the email to a single test user.
# Otherwise, the email will be sent to all prototype users.
# This uses the Mailersend API to send an email using the following template:
# https://app.mailersend.com/templates/351ndgwwnkngzqx8/edit

require 'csv'
require 'mailersend-ruby'

test_email_address = ARGV[0]

def send_email(user)
  mailersend_email = Mailersend::Email.new

  name = "#{user.first_name} #{user.last_name}"

  mailersend_email.add_recipients('email' => user.email, 'name' => name)
  mailersend_email.add_from('email' => 'communitylocator@simplyalwaysawake.com',
                            'name' => 'Simply Always Awake Community Locator')
  mailersend_email.add_subject('New and Improved! Simply Always Awake Community Locator')
  mailersend_email.add_template_id('351ndgwwnkngzqx8')
  mailersend_email.add_personalization(get_personalization(user))

  mailersend_email.send
end

def get_personalization(user)
  {
    email: user.email,
    data: {
      name: user.first_name,
      unsubscribe_url: get_unsubscribe_url(user)
    }
  }
end

def get_unsubscribe_url(user)
  Rails.application.routes.url_helpers
       .unsubscribe_url(
         host: ENV.fetch('HOST', 'communitylocator.simplyalwaysawake.com'),
         token: Rails.application.message_verifier(:unsubscribe).generate(user.id)
       )
end

if test_email_address
  puts 'Running in test mode'
  user = PrototypeUser.find_by(email: test_email_address)
  raise "PrototypeUser with email #{test_email_address} not found" unless user

  send_email(user)
  puts "Sent email to #{user.email}"
else
  puts 'Running in production mode'
  PrototypeUser.find_each do |user|
    # send_email(user)
    puts "Sent email to #{user.email}"
  rescue StandardError => e
    puts "Error sending email to #{user.email}: #{e.message}"
  ensure
    sleep(1)
  end
end
