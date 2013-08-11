require 'csv'

module DB

  class Import
    attr_reader :location
    attr_reader :drop_rows

    def initialize location, drop_rows
      @location = location
      @drop_rows = drop_rows
    end

    def self.csv_table filename, args = {}
      new(args.fetch(:location, 'import_data'), args.fetch(:drop_rows,0)).file_to_table filename
    end

    def file_to_table filename
      CSV.open( get_file(filename), headers: true, header_converters: :symbol, converters: lambda {|f| f ? f.strip : nil}).read.drop(drop_rows)
    end

    private

      def get_file filename
        "#{location}/#{filename}.csv"
      end
  end

end