# frozen_string_literal: true

require 'test_helper'

class AdminAccessTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'redirects anonymous users to sign in' do
    get admin_root_path
    assert_redirected_to new_user_session_path
  end

  test 'redirects non-admin users to root' do
    sign_in users(:john_doe)
    get admin_root_path
    assert_redirected_to root_path
    assert_equal 'You are not authorized to access this page.', flash[:alert]
  end

  test 'allows admin users into the dashboard' do
    sign_in users(:admin_user)
    get admin_root_path
    assert_response :success
  end

  test 'admin can view the searchable users index' do
    sign_in users(:admin_user)
    get admin_users_path
    assert_response :success
    assert_match users(:john_doe).email, response.body
  end

  test 'admin can view a user with location and options' do
    sign_in users(:admin_user)
    get admin_user_path(users(:john_doe))
    assert_response :success
  end

  test 'admin can render the new user form' do
    sign_in users(:admin_user)
    get new_admin_user_path
    assert_response :success
  end

  test 'admin can render the edit user form with location and options' do
    sign_in users(:admin_user)
    get edit_admin_user_path(users(:john_doe))
    assert_response :success
  end
end
