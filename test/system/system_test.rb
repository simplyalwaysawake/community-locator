# frozen_string_literal: true

require 'application_system_test_case'

class SystemTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @location = locations(:new_york)
  end

  test 'should sign in and create location' do
    # User jane_doe is registered but doesn't have a location
    user = users(:jane_doe)

    # Sign in
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password2'
    click_on 'Log in'

    # Enter name and telegram
    fill_in 'Name', with: 'John Doe'
    fill_in 'Telegram', with: 'johndoe'
    click_on 'Next'

    # Enter location
    fill_in 'City', with: 'New York'
    fill_in 'State', with: 'NY'
    fill_in 'Country', with: 'United States'
    fill_in 'Postal code', with: '10002'
    click_on 'Save'

    # We should be back on the community screen
    assert_text 'Simply Always Awake Community Locator'

    assert_text 'John Doe'
    assert_text 'New York, NY'
    assert_text 'john.doe@example.com'

    assert_link 'Edit location'
    assert_link 'Sign out'
  end

  test 'should update location' do
    # User john_doe already has a location
    sign_in users(:john_doe)
    visit root_url

    click_on 'Edit location', match: :first

    fill_in 'City', with: @location.city
    fill_in 'State', with: @location.state
    fill_in 'Country', with: @location.country
    fill_in 'Postal code', with: @location.postal_code

    click_on 'Save'

    assert_text 'Location saved'
  end
end
