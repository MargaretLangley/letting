require 'csv'
####
# Import Template
#
# These are the texts used in the invoices
#
####
namespace :db do
  namespace :import do
    filename = 'import_data/new/template.csv'
    desc 'Import invoice text from CSV file'
    task :template do
      if File.exist?(filename)
        CSV.foreach(filename, headers: true) do |row|
          begin
            # byebug
            Template.create!(row.to_hash)
          rescue
            p 'Template Create failed (see hash below):', row.to_hash
          end
        end
      else
        puts "Template not found: #{filename}"
      end
    end
  end
end
