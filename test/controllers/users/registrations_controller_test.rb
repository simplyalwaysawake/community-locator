# frozen_string_literal: true

require 'test_helper'

class Users::RegistrationControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'redirects to sign in after signing up' do
    post user_registration_path, params: { user: { email: 'john@example.com', password: 'password12' } }
    assert_redirected_to new_user_session_path
  end
end
