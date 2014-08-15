require 'csv'

# CSV Columns
#
# Column 1 - id
# Column 2 - the cycle
  # charge_cycle 1: 'Mar/Sep'
  # charge_cycle 2: 'Jun/Dec'
  # See import_charge_cycle.csv for remainder
# Column 3 - the billing
  # charged_in_id: 1 Arrears
  # charged_in_id: 2 Advance
  # charged_in_id: 3 Mid-Term

namespace :db do
  namespace :import do

    filename = 'import_data/new/charge_structure.csv'

    desc "Import charge structure from CSV file"
    task :charge_structure do
      puts "Charge Structure import: missing #{filename}" \
        unless File.exist?(filename)

      CSV.foreach(filename, :headers => true) do |row|
        ChargeStructure.create!(row.to_hash) unless comment(row)
      end
    end

    def comment row
      '#' == row['id'].first
    end
  end
end
