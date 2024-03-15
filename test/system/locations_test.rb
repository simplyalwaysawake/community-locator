require "application_system_test_case"

class LocationsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @location = locations(:one)
  end

  test "should sign in and create location" do
    # User test2 is registered but doesn't have a location
    user = users(:test2)

    # Sign in
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password2"
    click_on "Log in"

    # Enter location
    fill_in "City", with: "Omaha"
    fill_in "State", with: "NE"
    fill_in "Country", with: "United States"
    fill_in "Postal code", with: "68007"
    click_on "Save"

    # We should be back on the home screen
    assert_text "Simply Always Awake Community Locator"
    assert_link "Edit location"
    assert_link "Sign out"
  end

  test "should update location" do
    # User test1 already has a location
    sign_in users(:test1)
    visit root_url

    click_on "Edit location", match: :first

    fill_in "City", with: @location.city
    fill_in "State", with: @location.state
    fill_in "Country", with: @location.country
    fill_in "Postal code", with: @location.postal_code
    
    click_on "Save"

    assert_text "Location saved"
  end
end
