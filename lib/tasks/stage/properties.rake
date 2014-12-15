require_relative '../../stage/stage'

STDOUT.sync = true

#
# Properties
#
# Creates the properties staging file in the staging/ directory.
#
# stage task - stage tasks take legacy data and overwrite, when necessary,
#              any changes by the patch files and puts the resultant data
#              into the stage directory.
#
namespace :db do
  namespace :stage do
    desc 'Improves legacy property data quality by patching inaccuracies.'
    task :properties do
      Stage.new(file_name: 'import_data/staging/staging_properties.csv',
                input: properties,
                instructions: [PatchRef.new(patch: patch_properties)]).stage
    end

    def properties
      DB::CSVTransform.new file_name: 'import_data/legacy/properties.csv',
                           headers: DB::FileHeader.property,
                           drop_rows: 34
    end

    def patch_properties
      DB::CSVTransform.new(file_name: 'import_data/patch/properties_patch.csv',
                           headers: DB::FileHeader.property).to_a
    end
  end
end
