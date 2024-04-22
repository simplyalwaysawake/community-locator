# frozen_string_literal: true

# Usage: rails runner scripts/load_prototype_users.rb path/to/file.csv
# The file needs to have at least the columns 'Email Address', 'First Name', and 'Last Name'

require 'csv'

filename = ARGV[0]

CSV.foreach(filename, headers: true) do |row|
  PrototypeUser.create(email: row['Email Address'], first_name: row['First Name'], last_name: row['Last Name'])
end
