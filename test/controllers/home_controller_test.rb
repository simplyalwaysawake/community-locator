require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "shows sign up and sign in links when not logged in" do
    get home_index_url
    assert_select "a", "Sign up"
    assert_select "a", "Sign in"
  end

  test "shows sign out link when signed in" do
    result = sign_in users(:test1)
    get home_index_url
    assert_response :success
    assert_select "a", "Sign out"
  end
end
