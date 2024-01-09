CSV Validator and Geo Coordinates Fetcher CLI
Overview
This command-line interface (CLI) tool is designed to validate and enhance basic client information provided in a CSV file. The script is written in plain Ruby without using any frameworks, but it utilizes 3rd party gems for specific functionalities. The tool can be used as a micro-service, validating the input file and fetching GEO coordinates for each row.

Features
Validates client information in a CSV file.
Verifies addresses, ensuring no blank email, first and last name, and valid residential or postal addresses.
Checks for invalid location/postcode pairs (residential or postal).
Fetches GEO coordinates for each row.
Generates an output CSV file with invalid rows removed.
Usage
bash
Copy code
# Parses input.csv and prints output to STDOUT
./cli < input.csv

# Parses input.csv and produces output.csv as the result
./cli input.csv > output.csv

Dependencies
csv - Ruby's built-in CSV library.
geocoder - For fetching GEO coordinates.
Testing
To run the test suite, execute:

bash
Copy code
bundle exec rspec
Code Structure
cli.rb: Main script implementing CSV validation and GEO coordinates fetching.
csv_validator.rb: Module for validating CSV rows.
geo_coordinates_fetcher.rb: Module for fetching GEO coordinates.
cli_spec.rb: RSpec tests for the CLI functionality.
