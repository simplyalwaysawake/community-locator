# frozen_string_literal: true

require 'test_helper'

class OptionsControllerTest < ActionDispatch::IntegrationTest
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
          params: { options: { community_range: 1, user: } }
    assert_redirected_to root_path
  end
end
