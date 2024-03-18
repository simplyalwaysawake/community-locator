require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects to sign in page when not logged in" do
    get home_show_url
    assert_redirected_to new_user_session_path
  end

  test "shows sign out link when signed in" do
    result = sign_in users(:test1)
    get home_show_url
    assert_response :success
    assert_select "a", "Sign out"
  end

  test "redirects to location path if user has no location" do
    result = sign_in users(:test2)
    get home_show_url
    assert_redirected_to location_path
  end

  test "shows community if user has location" do
    sign_in users(:test1)
    get home_show_url
    assert_response :success
    assert_select "li", "user3@example.com (Newark, NJ)"
  end
end
