# frozen_string_literal: true

require 'test_helper'

class OptionsTest < ActiveSupport::TestCase
  test 'should set a default community range' do
    options = Options.create(user_id: 1)
    assert_equal 20, options.community_range
  end

  test 'should not accept a range above 100' do
    options = Options.create(user_id: 1, community_range: 101)
    assert_not options.valid?
    assert_equal ['must be less than or equal to 100'], options.errors.messages[:community_range]
  end
end
