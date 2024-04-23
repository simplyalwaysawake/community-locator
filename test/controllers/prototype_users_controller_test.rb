# frozen_string_literal: true

require 'test_helper'

class PrototypeUsersControllerTest < ActionDispatch::IntegrationTest
  test 'should unsubscribe user' do
    user = PrototypeUser.create(email: 'johndoe@example.com', first_name: 'John', last_name: 'Doe')
    token = Rails.application.message_verifier(:unsubscribe).generate(user.id)
    get unsubscribe_url, params: { token: }
    assert_response :success
    assert_equal 'You have unsubscribed from announcements.', assigns(:message)
    assert user.reload.unsubscribed_at
  end
end
