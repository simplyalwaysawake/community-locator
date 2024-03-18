# frozen_string_literal: true

require 'test_helper'

class CommunityControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'redirects to sign in page when not logged in' do
    get community_url
    assert_redirected_to new_user_session_path
  end

  test 'shows sign out link when signed in' do
    sign_in users(:test1)
    get community_url
    assert_response :success
    assert_select 'a', 'Sign out'
  end

  test 'redirects to location path if user has no location' do
    sign_in users(:test2)
    get community_url
    assert_redirected_to location_path
  end

  test 'shows community if user has location' do
    sign_in users(:test1)
    get community_url
    assert_response :success
    assert_select 'li', 'user3@example.com (Newark, NJ)'
  end
end