# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'shows sign up and sign in links if not signed in' do
    get home_show_url
    assert_select 'a', 'Get started'
    assert_select 'a', 'Sign in'
  end

  test 'redirects to community path if signed in' do
    sign_in users(:john_doe)
    get home_show_url
    assert_redirected_to community_path
  end
end
