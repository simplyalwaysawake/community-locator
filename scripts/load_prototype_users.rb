# frozen_string_literal: true

# Usage: ruby scripts/load_prototype_users.rb <server> <filename> <username> <password>
# Example: ruby scripts/load_prototype_users.rb http://localhost:3000 users.csv admin@example.com password123
# The CSV file needs to have at least the columns 'Email Address', 'First Name', and 'Last Name'
# This script is meant to be run from your local machine, not the server.

require 'csv'
require 'uri'
require 'net/http'

server = ARGV[0]
filename = ARGV[1]
username = ARGV[2]
password = ARGV[3]

CSV.foreach(filename, headers: true) do |row| # rubocop:disable Metrics/BlockLength
  email = row['Email Address']
  first_name = row['First Name']
  last_name = row['Last Name']

  url = URI("#{server}/api/prototype_users")

  http = Net::HTTP.new(url.host, url.port)
  if url.scheme == 'https'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  end

  request = Net::HTTP::Post.new(url)
  request['Content-Type'] = 'application/json'
  request['User-Agent'] = 'community-locator-script'
  request['Authorization'] = "Basic #{Base64.strict_encode64("#{username}:#{password}")}"
  request.body = <<~BODY
    {
      "prototype_user": {
        "email": "#{email}",
        "first_name": "#{first_name}",
        "last_name": "#{last_name}"
      }
    }
  BODY

  response = http.request(request)

  if response.code == '201'
    puts "Created user with email: #{row['Email Address']}"
  else
    puts "Error creating user with email: #{row['Email Address']}"
    puts response.code
  end

  sleep 1
end
