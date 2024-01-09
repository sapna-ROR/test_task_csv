require 'csv'
require 'geocoder'

if ARGV.empty?
  input_file = 'clients.csv'
else
  input_file = ARGV[0]
end

unless File.exist?(input_file)
  puts "Error: File #{input_file} not found."
  exit(1)
end

Geocoder::Configuration.timeout = 15

rows = CSV.read(input_file, headers: true)

valid_rows = rows.select do |row|
  valid_email = !row['Email'].to_s.empty?
  valid_name = !row['First Name'].to_s.empty? && !row['Last Name'].to_s.empty?
  valid_residential_address = !row['Residential Address Street'].to_s.empty? &&
                               !row['Residential Address Locality'].to_s.empty? &&
                               !row['Residential Address State'].to_s.empty? &&
                               !row['Residential Address Postcode'].to_s.empty?

  valid_postal_address = !row['Postal Address Street'].to_s.empty? &&
                         !row['Postal Address Locality'].to_s.empty? &&
                         !row['Postal Address State'].to_s.empty? &&
                         !row['Postal Address Postcode'].to_s.empty?

  valid_location_postcode = valid_residential_address || valid_postal_address

  valid_email && valid_name && valid_location_postcode &&
    row.fields.all? { |value| !value.to_s.empty? }
end

output_file = 'output.csv'

CSV.open(output_file, 'w', write_headers: true, headers: rows.headers + ['Latitude', 'Longitude']) do |csv|
  addresses = valid_rows.map do |row|
    "#{row['Residential Address Street']}, #{row['Residential Address Locality']}, #{row['Residential Address State']} #{row['Residential Address Postcode']}"
  end

  results = Geocoder.search(addresses)

  if results.is_a?(Array) && results.any? { |result| result.is_a?(Geocoder::Result::Base) }
    results.each_with_index do |result, index|
      latitude = result&.latitude || 0.0
      longitude = result&.longitude || 0.0
      csv << valid_rows[index].fields + [latitude, longitude]
    end
  else
    puts "Geocoding API error: #{results}"
  end
end

puts "Output written to #{output_file}"