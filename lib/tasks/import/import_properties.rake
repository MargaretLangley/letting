require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_property'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

#
# import_properties.rake
#
# Imports csv document and generates property objects.
#
# CSV files are converted into an 2D array indexed by row number
# and header symbols and passed to ImportProperty.import which
# builds and update Property objects.
#
namespace :db do
  namespace :import do

    desc 'Import properties data from CSV file'
    task :properties, [:range] => :environment do |_task, args|
      DB::ImportProperty.import \
        properties_file,
        range: Rangify.from_str(args.range).to_i,
        patch: DB::Patch.import(Property, patch_properties)
    end

    # Takes csv file and returns an array of arrays.
    # Elements of the array are indexed by symbols taken
    # from the row header.
    #
    def properties_file
      DB::FileImport.to_a 'properties',
                          headers: DB::FileHeader.property,
                          location: 'import_data/legacy',
                          drop_rows: 34
    end

    # Takes a csv file which corrects mistakes in the properties CSV.
    #
    def patch_properties
      DB::FileImport.to_a 'properties_patch',
                          headers: DB::FileHeader.property,
                          location: 'import_data/patch'
    end
  end
end
