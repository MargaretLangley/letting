require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_property'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

namespace :db do
  namespace :import do

    desc "Import properties data from CSV file"
    task :properties, [:range] => :environment do |task, args|
      DB::ImportProperty.import properties_file,
                                range: Rangify.from_str(args.range).to_i,
                                patch: DB::Patch.import(Property, patch_properties)
     end

     def properties_file
       DB::FileImport.to_a 'properties',
                           headers: DB::FileHeader.property,
                           location: 'import_data/legacy',
                           drop_rows: 34
     end

     def patch_properties
       DB::FileImport.to_a 'properties_patch',
                           headers: DB::FileHeader.property,
                           location: 'import_data/patch'
     end
   end
end