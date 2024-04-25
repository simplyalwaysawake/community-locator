# frozen_string_literal: true

require 'test_helper'

class UserOptionsTest < ActiveSupport::TestCase
  setup do
    @user = users(:john_doe)
  end

  test 'should set a default community range' do
    options = UserOptions.create(user_id: @user.id)
    assert options.valid?
    assert_equal 20, options.community_range
  end

  test 'should accept max range of 200' do
    options = UserOptions.create(user_id: @user.id, community_range: 200)
    assert options.valid?
  end

  test 'should not accept a range above 200' do
    options = UserOptions.create(user_id: @user.id, community_range: 201)
    assert_not options.valid?
    assert_equal ['must be less than or equal to 200'], options.errors.messages[:community_range]
  end
end
