require 'csv'

namespace :db do
  namespace :import do

    filename = 'import_data/new/charged_in.csv'

    desc "Import charged in data from CSV file"
    task :charged_ins do
      puts "ChargedIn import: missing #{filename}" unless File.exist?(filename)

      CSV.foreach(filename, :headers => true) do |row|
        ChargedIn.create!(row.to_hash)
      end
    end
  end
end
