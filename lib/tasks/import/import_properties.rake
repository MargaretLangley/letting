require 'csv'
require_relative '../../import/import'
require_relative '../../import/import_fields'
require_relative '../../import/import_property'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

namespace :import do

  desc "Import properties data from CSV file"
  task  properties: :environment do
    DB::ImportProperty.import \
    DB::Import.csv_table('properties', \
      headers: DB::ImportFields.property, drop_rows: 34), \
        DB::Patch.import(Property, DB::Import.csv_table('properties_patch', \
          headers: DB::ImportFields.property, location: 'import_data/patch'))
   end
end