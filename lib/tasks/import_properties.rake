require 'csv'
require_relative '../import/import'
require_relative '../import/import_property'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

namespace :db do

  desc "Import properties data from CSV file"
  task  import_properties: :environment do
    DB::ImportProperty.import DB::Import.csv_table('properties', drop_rows: 33)
   end
end