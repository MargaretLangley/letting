require 'csv'

# CSV Columns
#
# Column 1 - id
# Column 2 - ChargeStructure (1-10)
  # 1 = 'Mar 25th/Sep 29th', 'Arrears'
  # 2 = 'Jun 24th/Dec 25th', 'Arrears'
  # See ChargeStructure CSV for more information.
# Column 3 - Month (1-12)
# Column 4 - Day (1 - 31)

namespace :db do
  namespace :import do

    filename = 'import_data/new/due_ons.csv'

    desc "Import due_ons from CSV file"
    task :due_ons, [:test] => :environment  do
      puts "DueOns import: missing #{filename}" \
        unless File.exist?(filename)

      CSV.foreach(filename, :headers => true) do |row|
        DueOn.create!(row.to_hash) unless comment(row)
      end
    end

    def comment row
      '#' == row['id'].first
    end
  end
end
