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

  test 'opens the community map at the admin root for admin users' do
    sign_in users(:admin_user)
    get admin_root_path
    assert_response :success
    assert_select '[data-admin-community-map]'
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

  test 'admin can view the community map' do
    sign_in users(:admin_user)

    get admin_community_map_path

    assert_response :success
    assert_select '[data-admin-community-map][data-members-url]'
    assert_select '[data-draw-shape="Circle"]'
    assert_select '[data-draw-shape="Polygon"]'
    assert_select '[data-copy-emails]'
    assert_select '[data-download-selection]'
    assert_select 'script[src*="es-module-shims"]'
    assert_select 'script[type="esms-options"]', text: /shimMode/
    assert_select 'script[type="importmap-shim"]' do |maps|
      assert_includes maps.first.text, '"active_admin"'
      assert_includes maps.first.text, '"leaflet"'
    end
    assert_select 'script[type="module-shim"]', text: /import "active_admin"/
    assert_select 'script[type="module-shim"][src*="admin/community_map"]'
  end

  test 'non-admin users cannot view the community map' do
    sign_in users(:john_doe)

    get admin_community_map_path

    assert_redirected_to root_path
  end

  test 'admin can load the allowlisted community map data' do
    sign_in users(:admin_user)

    get admin_community_map_members_path, as: :json

    assert_response :success
    assert_includes response.headers.fetch('Cache-Control'), 'no-store'

    payload = response.parsed_body
    john = payload.fetch('users').find { |user| user.fetch('id') == users(:john_doe).id }

    assert_equal User.count, payload.fetch('total_count')
    assert_equal(
      %w[email id latitude location longitude name telegram],
      john.keys.sort
    )
    assert_equal 'john.doe@example.com', john.fetch('email')
    assert_not(payload.fetch('users').any? { |user| user.fetch('id') == users(:jane_doe).id })
  end

  test 'non-admin users cannot load community map data' do
    sign_in users(:john_doe)

    get admin_community_map_members_path, as: :json

    assert_redirected_to root_path
  end
end
