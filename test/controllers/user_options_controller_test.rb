# frozen_string_literal: true

require 'test_helper'

class UserOptionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'should get edit' do
    user = users(:john_doe)
    sign_in user
    get options_url
    assert_equal 20, assigns(:options).community_range
    assert_response :success
  end

  test 'should update options' do
    user = users(:john_doe)
    sign_in user
    patch options_url(@options),
          params: { user_options: { community_range: 1, notify_on_new_users: true, user: } }
    assert_redirected_to root_path

    user.reload
    assert_equal 1, user.user_options.community_range
    assert user.user_options.notify_on_new_users
  end
end
