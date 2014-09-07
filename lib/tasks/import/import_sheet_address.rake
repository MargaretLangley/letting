require 'csv'
####
# Import Sheet Address
#
# These are the texts used in the invoices for F&L Adam's address
#
####
namespace :db do
  namespace :import do

    filename = 'import_data/new/sheet_address.csv'

    desc "Import invoice text F&L Adam's address from CSV file"
    task :sheet_address do
      puts "Sheet Address import: missing #{filename}" unless File.exist?(filename)

      CSV.foreach(filename, :headers => true) do |row|
        begin
          Address.create!(row.to_hash)
        rescue Exception => exception
          p "Sheet Address Create failed (see hash below):", row.to_hash
        end
      end
    end
  end
end
