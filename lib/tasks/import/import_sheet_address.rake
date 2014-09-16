require 'csv'
####
# Import Sheet Address
#
# addressable_id: 1
#
# These are the texts used in the invoices for F&L Adam's address
#
####
namespace :db do
  namespace :import do

    filename = 'import_data/new/sheet_address.csv'

    desc "Import invoice text F&L Adam's address from CSV file"
    task :sheet_address do
      if File.exist?(filename)
        CSV.foreach(filename, headers: true) do |row|
          begin
            Address.create!(row.to_hash)
          rescue
            p 'Sheet Address Create failed (see hash below):', row.to_hash
          end
        end
      else
        puts "Sheet Address not found: #{filename}"
       end
    end
  end
end
