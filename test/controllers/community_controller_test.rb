# frozen_string_literal: true

require 'test_helper'

class CommunityControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'redirects to sign in page when not logged in' do
    get community_url
    assert_redirected_to new_user_session_path
  end

  test 'shows sign out link when signed in' do
    sign_in users(:john_doe)
    get community_url
    assert_response :success
    assert_select 'a', 'Sign out'
  end

  test 'redirects to location path if user has no location' do
    sign_in users(:greg_anderson)
    get community_url
    assert_redirected_to location_path
  end

  test 'redirects to slimmed-down registration edit path if user has location but no name' do
    sign_in users(:user3)
    get community_url
    assert_redirected_to edit_user_registration_path(nil, welcome: true)
  end

  test 'redirects to slimmed-down registration edit path if user has no name nor location' do
    sign_in users(:user5)
    get community_url
    assert_redirected_to edit_user_registration_path(nil, welcome: true)
  end

  test 'shows community if user has location and name' do
    sign_in users(:john_doe)
    get community_url
    assert_response :success
    assert_select 'td', /user3/
  end
end
