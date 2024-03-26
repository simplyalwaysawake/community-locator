# frozen_string_literal: true

require 'test_helper'

class TermsControllerTest < ActionDispatch::IntegrationTest
  test 'should get terms' do
    get terms_url
    assert_response :success
  end
end
