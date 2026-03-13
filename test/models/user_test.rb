# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should strip whitespace from name' do
    user = users(:john_doe)
    user.name = '  John Doe  '
    user.valid?
    assert_equal 'John Doe', user.name
  end

  test 'should strip whitespace from telegram' do
    user = users(:john_doe)
    user.telegram = '  johndoe  '
    user.valid?
    assert_equal 'johndoe', user.telegram
  end

  test 'should strip leading @ from telegram' do
    user = users(:john_doe)
    user.telegram = '@johndoe'
    user.valid?
    assert_equal 'johndoe', user.telegram
  end

  test 'should strip whitespace and leading @ from telegram' do
    user = users(:john_doe)
    user.telegram = '  @johndoe  '
    user.valid?
    assert_equal 'johndoe', user.telegram
  end

  test 'should have one location' do
    user = users(:john_doe)
    assert user.location
    assert_instance_of Location, user.location
  end

  test 'should have one user_options' do
    user = users(:john_doe)
    assert user.user_options
    assert_instance_of UserOptions, user.user_options
  end

  test 'should not require password on update when password is blank' do
    user = users(:john_doe)
    user.name = 'Updated Name'
    assert user.valid?
  end

  test 'should handle nil name gracefully' do
    user = users(:john_doe)
    user.name = nil
    user.valid?
    assert_nil user.name
  end

  test 'should handle nil telegram gracefully' do
    user = users(:john_doe)
    user.telegram = nil
    user.valid?
    assert_nil user.telegram
  end
end
