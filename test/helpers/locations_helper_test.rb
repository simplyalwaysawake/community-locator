# frozen_string_literal: true

require 'test_helper'

class LocationsHelperTest < ActionView::TestCase
  test 'should return city and state' do
    location = locations(:albany)
    assert_equal 'Albany, NY', short_address(location)
  end

  test 'should return only city' do
    location = Location.new({ city: 'Denver' })
    assert_equal 'Denver', short_address(location)
  end

  test 'should return only state' do
    location = Location.new({ state: 'CO' })
    assert_equal 'CO', short_address(location)
  end

  test 'should return country and postal code' do
    location = Location.new({ country: 'USA', postal_code: '10001' })
    assert_equal 'USA 10001', short_address(location)
  end

  test 'should return only country' do
    location = Location.new({ country: 'USA' })
    assert_equal 'USA', short_address(location)
  end

  test 'should return only postal code' do
    location = Location.new({ postal_code: '10001' })
    assert_equal '10001', short_address(location)
  end
end
