# frozen_string_literal: true

if Rails.env.test?
  Geocoder.configure(lookup: :test)
  Geocoder::Lookup::Test.set_default_stub(
    [
      {
        'coordinates' => [40.7143528, -74.0059731],
        'address' => 'New York, NY, USA 10001',
        'state' => 'New York',
        'state_code' => 'NY',
        'country' => 'United States',
        'country_code' => 'US',
        'postal_code' => '10001'
      }
    ]
  )

  Geocoder::Lookup::Test.add_stub(
    'Ko Phangan, Thailand', [
      {
        'coordinates' => [nil, nil],
        'address' => 'Ko Phangan, Thailand',
        'city' => 'Ko Phangan',
        'state' => nil,
        'state_code' => nil,
        'country' => 'Thailand'
      }
    ]
  )
else
  Geocoder.configure(
    # Geocoding options
    # timeout: 3,                 # geocoding service timeout (secs)
    lookup: :here, # name of geocoding service (symbol)
    # ip_lookup: :ipinfo_io,      # name of IP address geocoding service (symbol)
    # language: :en,              # ISO-639 language code
    # use_https: false,           # use HTTPS for lookup requests? (if supported)
    # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
    # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
    api_key: ENV.fetch('HERE_API_KEY', nil), # API key for geocoding service
    # cache: nil,                 # cache object (must respond to #[], #[]=, and #del)

    # Exceptions that should not be rescued by default
    # (if you want to implement custom error handling);
    # supports SocketError and Timeout::Error
    # always_raise: [],

    # Calculation options
    units: :mi # :km for kilometers or :mi for miles
    # distances: :linear          # :spherical or :linear

    # Cache configuration
    # cache_options: {
    #   expiration: 2.days,
    #   prefix: 'geocoder:'
    # }
  )
end
