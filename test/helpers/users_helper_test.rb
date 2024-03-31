# frozen_string_literal: true

require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'should return name if present' do
    user = users(:john_doe)
    assert_equal 'John Doe', display_name(user)
  end

  test 'should return email if name is not present' do
    user = users(:jane_doe)
    assert_equal 'jane.doe', display_name(user)
  end

  test 'should return telegram with @ if present' do
    user = users(:john_doe)
    assert_equal '@johndoe', display_telegram(user)
  end

  test 'should return empty string if telegram not present' do
    user = users(:jane_doe)
    assert_equal '', display_telegram(user)
  end

  test 'should return empty string if telegram blank' do
    user = users(:jane_doe)
    user.update(telegram: '')
    user.reload
    assert_equal '', display_telegram(user)
  end
end
