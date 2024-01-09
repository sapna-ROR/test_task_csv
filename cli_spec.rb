require 'rspec'
require 'csv'
require_relative 'cli'

describe 'CLI Script' do
  context 'when providing a valid CSV file' do
    let(:input_csv) { '/home/developer/ruby/clients.csv' }

    it 'outputs a CSV file with valid rows and coordinates' do
      output = `ruby cli.rb #{input_csv}`
      expect(output).to include('Output written to output.csv')
    end
  end
end
