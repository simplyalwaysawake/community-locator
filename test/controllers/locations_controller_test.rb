require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @location = locations(:new_york)
  end

  test "should get index" do
    sign_in users(:test1)
    get location_url
    assert_response :success
  end

  test "should create location" do
    user = users(:test2)
    sign_in user
    refute user.location
    
    params = {
      location: {
        city: @location.city,
        state: @location.state,
        country: @location.country,
        postal_code: @location.postal_code
      }
    }

    post location_url, params: params
    assert user.location

    assert_redirected_to root_path
  end

  test "should update location" do
    user = users(:test1)
    sign_in user
    patch location_url, params: {
      location: {
        city: "Updated city",
        state: "Updated state",
        country: "Updated country",
        postal_code: "Updated postal code"
      }
    }

    assert_equal "Updated city", user.location.city
    assert_equal "Updated state", user.location.state
    assert_equal "Updated country", user.location.country
    assert_equal "Updated postal code", user.location.postal_code

    assert_redirected_to root_path
  end
end
