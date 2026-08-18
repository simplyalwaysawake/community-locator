# frozen_string_literal: true

class AdminMapData
  LOCATION_KEYS = %i[city state country postal_code].freeze
  MAP_KEYS = %i[id name email telegram latitude longitude].freeze
  ROW_KEYS = (MAP_KEYS + LOCATION_KEYS).freeze
  USER_COLUMNS = [
    'users.id',
    'users.name',
    'users.email',
    'users.telegram',
    'locations.latitude',
    'locations.longitude',
    'locations.city',
    'locations.state',
    'locations.country',
    'locations.postal_code'
  ].freeze

  def self.call
    { users: mapped_user_rows.map { |row| serialize(row) }, total_count: User.count }
  end

  def self.mapped_user_rows
    User
      .joins(:location)
      .where.not(locations: { latitude: nil })
      .where.not(locations: { longitude: nil })
      .order('users.id')
      .pluck(*USER_COLUMNS)
  end
  private_class_method :mapped_user_rows

  def self.serialize(row)
    row_data = ROW_KEYS.zip(row).to_h
    map_data(row_data).merge(location: short_address(**row_data.slice(*LOCATION_KEYS)))
  end
  private_class_method :serialize

  def self.map_data(row_data)
    row_data.slice(*MAP_KEYS).merge(
      name: row_data[:name].presence || row_data[:email].split('@').first,
      latitude: row_data[:latitude].to_f,
      longitude: row_data[:longitude].to_f
    )
  end
  private_class_method :map_data

  def self.short_address(city:, state:, country:, postal_code:)
    if city.present? || state.present?
      [city, state].compact_blank.join(', ')
    else
      [country, postal_code].compact_blank.join(' ')
    end
  end
  private_class_method :short_address
end
