require 'csv'
####
# Import Template Guide
#
# These are the texts used in the invoices for F&L Adam's guides
#
####
namespace :db do
  namespace :import do

    filename = 'import_data/new/template_guide.csv'

    desc "Import invoice text F&L Adam's guides from CSV file"
    task :template_guide do
      if File.exist?(filename)
        CSV.foreach(filename, headers: true) do |row|
          begin
            Guide.create! row.to_hash
          rescue StandardError => e
            p 'Template Guide Create failed (see hash below):', row.to_hash
            raise e
          end
        end
      else
        puts "Template Guide not found: #{filename}"
      end
    end
  end
end
