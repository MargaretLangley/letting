require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_property'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

namespace :import do

  desc "Import properties data from CSV file"
  task  properties: :environment do
    DB::ImportProperty.import \
    DB::FileImport.to_a('properties',
      headers: DB::FileHeader.property, drop_rows: 34),
        DB::Patch.import(Property, DB::FileImport.to_a('properties_patch',
          headers: DB::FileHeader.property, location: 'import_data/patch'))
   end
end