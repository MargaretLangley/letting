require 'csv'

####
# Import ChargeCycle
#
# Key value table: id, ChargeCycle Name
#
# 1 Mar/Sep
# 2 Jun/Dec
# 3 Mar/Jun/Sep/Dec
# 4 Apr/July/Oct/Jan
# see definitive values in table charge_cycles / file charge_cycle.csv
#
####
namespace :db do
  namespace :import do

    filename = 'import_data/new/charge_cycle.csv'

    desc "Import charge cycles from CSV file"
    task :charge_cycle do
      puts "Charge cycle import: missing #{filename}" unless File.exist?(filename)

      CSV.foreach(filename, :headers => true) do |row|
        begin
          ChargeCycle.create!(row.to_hash) unless comment(row)
        rescue Exception => exception
            p "ChargeCycle Create failed (see hash below):", row.to_hash
        end
      end
    end

    def comment row
      '#' == row['id'].first
    end
  end
end