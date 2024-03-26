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
    click_on 'Sign up'

    # We should be on the sign in page with a message about confirming the email
    assert_text 'Sign in'
    assert_text 'A message with a confirmation link has been sent to your email address'

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

    # We should be back on the community screen
    assert_text 'John Doe'
    assert_text 'New York, NY'
    assert_text 'john.doe@example.com'
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
