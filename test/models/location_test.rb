# frozen_string_literal: true

require 'test_helper'

class LocationTest < ActiveSupport::TestCase # rubocop:disable Metrics/ClassLength
  test 'should create a location' do
    assert Location.create(
      user: users(:jane_doe),
      city: 'New York',
      state: 'NY',
      country: 'USA',
      postal_code: '10001'
    )
  end

  test 'should update a location' do
    user = users(:john_doe)
    assert user.location.update({
                                  city: 'Los Angeles',
                                  state: 'CA',
                                  country: 'USA',
                                  postal_code: '90001'
                                })

    assert_equal 'Los Angeles', user.location.city
    assert_equal 'CA', user.location.state
    assert_equal 'USA', user.location.country
    assert_equal '90001', user.location.postal_code
  end

  test 'should not allow more than one location for a user' do
    user = users(:john_doe)
    assert user.location

    location = Location.new(
      user:,
      city: 'New York',
      state: 'NY',
      country: 'USA',
      postal_code: '10001'
    )

    assert_not location.save
    assert_equal 'User already has a location', location.errors.where(:base).first.full_message
  end

  test 'should return address with all fields present' do
    location = Location.new({
                              city: 'New York',
                              state: 'NY',
                              country: 'USA',
                              postal_code: '10001'
                            })
    assert_equal 'New York, NY, USA 10001', location.address
  end

  test 'should format address without city' do
    location = Location.new({
                              city: '',
                              state: 'NY',
                              country: 'USA',
                              postal_code: '10001'
                            })
    assert_equal 'NY, USA 10001', location.address
  end

  test 'should format address without state' do
    location = Location.new({
                              city: 'New York',
                              country: 'USA',
                              postal_code: '10001'
                            })
    assert_equal 'New York, USA 10001', location.address
  end

  test 'should format address without country' do
    location = Location.new({
                              city: 'New York',
                              state: 'NY',
                              postal_code: '10001'
                            })
    assert_equal 'New York, NY 10001', location.address
  end

  test 'should format address with only state and country' do
    location = Location.new({
                              state: 'NY',
                              country: 'USA'
                            })
    assert_equal 'NY, USA', location.address
  end

  test 'should format address with only city and postal code' do
    location = Location.new({
                              city: 'New York',
                              postal_code: '10001'
                            })
    assert_equal 'New York 10001', location.address
  end

  test 'should strip whitespace from fields' do
    location = Location.create({
                                 city: ' Saint Paul  ',
                                 state: '  MN ',
                                 country: 'USA ',
                                 postal_code: ' 55101'
                               })

    assert_equal 'Saint Paul', location.city
    assert_equal 'MN', location.state
    assert_equal 'USA', location.country
    assert_equal '55101', location.postal_code
  end

  test 'should geolocate address' do
    Geocoder::Lookup::Test.add_stub(
      'Minneapolis, MN, United States 55439',
      [{ 'coordinates' => [44.86747, -93.35977] }]
    )
    location = Location.create({
                                 city: 'Minneapolis',
                                 state: 'MN',
                                 country: 'United States',
                                 postal_code: '55439'
                               })

    assert_equal 44.86747, location.latitude
    assert_equal(-93.35977, location.longitude)
  end

  test 'should re-geolocate address on update' do
    location = locations(:new_york)
    assert_not_equal 44.86747, location.latitude
    assert_not_equal(-93.35977, location.longitude)

    Geocoder::Lookup::Test.add_stub(
      'Minneapolis, MN, United States 55439',
      [{ 'coordinates' => [44.86747, -93.35977] }]
    )
    location.update({
                      city: 'Minneapolis',
                      state: 'MN',
                      country: 'United States',
                      postal_code: '55439'
                    })

    assert_equal 44.86747, location.latitude
    assert_equal(-93.35977, location.longitude)
  end

  test 'not all fields can be blank' do
    location = Location.new
    assert_not location.save
    assert_equal 'At least one field must have a value', location.errors.where(:base).first.full_message
  end

  test 'clear coordinates' do
    location = locations(:new_york)
    location.clear_coordinates
    assert_nil location.latitude
    assert_nil location.longitude
  end

  test 'coordinates?' do
    location = locations(:new_york)
    assert location.coordinates?

    location.clear_coordinates
    assert_not location.coordinates?
  end

  test 'should not save location without coordinates' do
    location = Location.new(
      {
        city: 'Ko Phangan',
        state: '',
        country: 'Thailand'
      }
    )
    location.user = users(:jane_doe)

    assert_not location.save

    expected_error = [
      'We were unable to verify your location. ',
      'Please check your entries and try again. ',
      'If any fields are blank, try filling them in.'
    ].join
    assert_equal expected_error, location.errors.where(:base).first.full_message
  end
end
