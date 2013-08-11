require 'csv'

namespace :db do

  class Import
    attr_reader :location

    def initialize location
      @location = location
    end

    def self.csv_table filename, location = 'import_data'
      new(location).file_to_table filename
    end

    def file_to_table filename
      CSV.open( get_file(filename), headers: true, header_converters: :symbol, converters: lambda {|f| f ? f.strip : nil}).read
    end

    private

      def get_file filename
        "#{location}/#{filename}.csv"
      end
  end

end