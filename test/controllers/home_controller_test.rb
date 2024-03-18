require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "shows sign up and sign in links if not signed in" do
    get home_show_url
    assert_select "a", "Sign up"
    assert_select "a", "Sign in"
  end

  test "redirects to community path if signed in" do
    result = sign_in users(:test1)
    get home_show_url
    assert_redirected_to community_path
  end
end
