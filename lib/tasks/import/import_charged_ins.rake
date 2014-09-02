require 'csv'

###
# Import Charged Ins
#
# Key values table id, structuring of payments name
#
# Imported into charged_ins table
# Arrears is 1
# Advance is 2
# Mid-Term is 3
# See table charged_ins / file charged_in.csv for definitive values.
#
####
namespace :db do
  namespace :import do

    filename = 'import_data/new/charged_in.csv'

    desc "Import charged in data from CSV file"
    task :charged_ins do
      if File.exist?(filename)
        CSV.foreach(filename, :headers => true) do |row|
          ChargedIn.create!(row.to_hash)
        end
      else
        puts "ChargedIn import: missing #{filename}"
        load_test_charged_in
      end
    end

    private

    def load_test_charged_in
      ChargedIn.create! [
        {
          id: 1,
          name: 'Arrears'
        },
        {
          id: 2,
          name: 'Advance'
        }
      ]
    end
  end
end
