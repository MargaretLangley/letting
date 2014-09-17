require 'csv'
####
# Import Sheet Notice
#
# These are the texts used in the invoices for F&L Adam's notices
#
####
namespace :db do
  namespace :import do

    filename = 'import_data/new/sheet_notice.csv'

    desc "Import invoice text F&L Adam's notices from CSV file"
    task :sheet_notice do
      if File.exist?(filename)
        CSV.foreach(filename, headers: true) do |row|
          begin
            Notice.create!(row.to_hash)
          rescue
            p 'Sheet Notice Create failed (see hash below):', row.to_hash
          end
        end
      else
        puts "Sheet Notice not found: #{filename}"
      end
    end
  end
end
