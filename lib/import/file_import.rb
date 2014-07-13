require 'csv'

module DB
  ####
  #
  # FileImport
  #
  # Opens a CSV file and reads it into an array of arrays.
  #
  # How does this fit into the larger system?
  #
  # This is the first part of the importing system. The data is available to
  # this system through a number of CSV files. This class if responsible for
  # opening the CSV files and returning the information as an array of arrays.
  # The allows the rest of the system to be unaware of the format of the data.
  #
  # The importing system receives arrays which are indexed by
  # symbols matching the attributes of the models - allowing mass assignment
  # where appropriate.
  #
  # The symbols are set in the headers intiailizer
  #
  # In short the remaining import system has a class for each model and uses
  # the shared import_base for much of the work.
  # The arrays are read into the import_base where the actual importation
  # occurs.
  #
  ####
  class FileImport
    attr_reader :location

    def initialize location, drop_rows, headers
      @location = location
      @drop_rows = drop_rows
      @headers = headers
    end

    def self.to_a filename, args = {}
      new(args.fetch(:location, 'import_data'),
          args.fetch(:drop_rows, 1),
          args.fetch(:headers, true)).csv_to_arrays filename
    end

    def csv_to_arrays filename
      CSV.open(get_file(filename),
               encoding: 'windows-1251:utf-8',
               headers: @headers,
               header_converters: :symbol,
               converters: ->(f) { f ? f.strip : nil})
         .read.drop(@drop_rows)
    end

    private

    def get_file filename
      "#{@location}/#{filename}.csv"
    end
  end
end
