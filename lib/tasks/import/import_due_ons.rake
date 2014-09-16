require 'csv'

# CSV Columns
#
# Column 1 - id
# Column 2 - Ref ChargeCycle (1-12 currently)
# Charge Cycle structure
# id, name, order
# 1, 'Mar 25th/Sep 29th', 3
# See ChargeCycle CSV for more examples.
# Column 3 - Year (nil or 2014-2015)
# Column 4 - Month (1-12)
# Column 5 - Day (1 - 31)

namespace :db do
  namespace :import do

    filename = 'import_data/new/due_ons.csv'

    desc 'Import due_ons from CSV file'
    task :due_ons, [:test] => :environment  do
      puts "DueOns import: missing #{filename}" \
        unless File.exist?(filename)

      CSV.foreach(filename, headers: true) do |row|
        DueOn.create!(row.to_hash) unless comment(row)
      end
    end

    def comment row
      '#' == row['id'].first
    end
  end
end
