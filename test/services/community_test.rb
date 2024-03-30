# frozen_string_literal: true

require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  test '#for should return only one user' do
    user = users(:john_doe)
    community = Community.for(user)
    assert_equal 1, community.count
    assert_equal users(:user3).id, community.first.id
  end

  test 'should return empty array if user has no location' do
    user = users(:jane_doe)
    community = Community.for(user)
    assert community.empty?
  end
end
