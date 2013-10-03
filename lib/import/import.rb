require 'csv'

module DB

  class Import
    attr_reader :location

    def initialize location, drop_rows, headers
      @location = location
      @drop_rows = drop_rows
      @headers = headers
    end

    def self.csv_table filename, args = {}
      new(args.fetch(:location, 'import_data'),
          args.fetch(:drop_rows, 1),
          args.fetch(:headers, true)).file_to_table filename
    end

    def file_to_table filename
      CSV.open(get_file(filename),
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
