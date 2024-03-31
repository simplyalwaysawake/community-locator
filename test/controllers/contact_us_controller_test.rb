# frozen_string_literal: true

require 'test_helper'

class ContactUsControllerTest < ActionDispatch::IntegrationTest
  test 'sends email when contact form is submitted' do
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      post contact_us_url, params: { name: 'John Doe', email: 'john.doe@example.com', message: 'Hello' }
    end
  end

  test 'redirects to root path after sending email' do
    post contact_us_url, params: { name: 'John Doe', email: 'john.doe@example.com', message: 'Hello' }
    assert_redirected_to root_path
  end

  test 'shows contact us page' do
    get contact_us_url
    assert_response :success
    assert_select 'h2', 'Contact Us'
  end
end
