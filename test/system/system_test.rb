# frozen_string_literal: true

require 'application_system_test_case'

class SystemTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @location = locations(:new_york)
  end

  test 'registration flow' do # rubocop:disable Metrics/BlockLength
    # Sign up
    visit root_path
    click_on 'Get started'

    email = 'jimmy@example.com'
    password = 'password'

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    check 'user-agreement'
    check 'consent-to-share-email'
    click_on 'Sign up'

    # We should be on the sign in page with a message about confirming the email
    assert_text 'Sign in'
    message = [
      'You should receive an email with a confirmation link within a few minutes ',
      '(you may need to check your spam folder). Please follow the link to activate your account.'
    ].join
    assert_text message

    # Confirm email
    token = ActionMailer::Base.deliveries.last.body.match(/confirmation_token=(.*)"/)[1]
    visit user_confirmation_path(confirmation_token: token)

    # Sign in
    visit new_user_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Sign in'

    # Enter name and telegram
    fill_in 'Name', with: 'John Doe'
    fill_in 'Telegram', with: 'johndoe'
    click_on 'Next'

    # Enter location
    fill_in 'City', with: 'New York'
    fill_in 'State', with: 'NY'
    fill_in 'Country', with: 'United States'
    fill_in 'Postal Code', with: '10002'
    click_on 'Next'

    # Enter options
    select '10', from: 'Community Range (miles)'
    check 'user_options_notify_on_new_users'
    click_on 'Finish'

    # We should be back on the community screen
    assert_text 'John Doe'
    assert_text 'New York, NY'
    assert_text 'john.doe@example.com'

    # Send email with list
    click_on 'Email this list to me'
    sleep 3 # Wait for email to be sent
    assert ActionMailer::Base.deliveries.last.html_part.body.match(/John Doe/)

    # Sign out
    click_on('Sign out', match: :first)
    assert_text 'Signed out successfully'
    assert_text 'Sign in'

    # Verify data
    jimmy = User.where(email:).first
    assert_equal 'John Doe', jimmy.name
    assert_equal 'johndoe', jimmy.telegram

    assert_equal 'New York', jimmy.location.city
    assert_equal 'NY', jimmy.location.state
    assert_equal 'United States', jimmy.location.country
    assert_equal '10002', jimmy.location.postal_code

    assert_equal 10, jimmy.user_options.community_range
    assert jimmy.user_options.notify_on_new_users
  end

  test 'should update location' do
    # User john_doe already has a location
    sign_in users(:john_doe)
    visit root_url

    click_on 'Location', match: :first

    fill_in 'City', with: @location.city
    fill_in 'State', with: @location.state
    fill_in 'Country', with: @location.country
    fill_in 'Postal Code', with: @location.postal_code

    click_on 'Save'

    assert_text 'Location saved'
  end
end
