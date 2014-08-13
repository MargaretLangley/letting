require 'csv'

namespace :db do
  namespace :import do

    filename = 'import_data/new/charge_cycle.csv'

    desc "Import charge cycles from CSV file"
    task :charge_cycle do
      puts "Charge cycle import: missing #{filename}" unless File.exist?(filename)

      CSV.foreach(filename, :headers => true) do |row|
        ChargeCycle.create!(row.to_hash)
      end
    end
  end
end
