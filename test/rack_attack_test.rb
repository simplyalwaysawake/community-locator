# frozen_string_literal: true

require 'test_helper'

class CommunityControllerTest < ActionDispatch::IntegrationTest
  setup do
    @original_cache_store = Rack::Attack.cache.store
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  teardown do
    Rack::Attack.cache.store = @original_cache_store
  end

  test 'throttles requests' do
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    user = users(:john_doe)
    6.times do
      post user_session_path, params: { user: { email: user.email, password: 'password' } }
    end
    assert_response :too_many_requests
  end
end
