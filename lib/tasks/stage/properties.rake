require_relative '../../stage/stage'

STDOUT.sync = true

namespace :db do
  namespace :stage do
    desc 'Improves legacy property data quality by patching inaccuracies.'
    task :properties do
      Stage.new(file_name: 'import_data/staging/staging_properties.csv',
                input: properties,
                patch: PatchRef.new(patch: patch_properties.to_a)).stage
    end

    def properties
      DB::CSVTransform.new file_name: 'import_data/legacy/properties.csv',
                           headers: DB::FileHeader.property,
                           drop_rows: 34
    end

    # Takes a csv file which corrects mistakes in the properties CSV.
    #
    def patch_properties
      DB::CSVTransform.new file_name: 'import_data/patch/properties_patch.csv',
                           headers: DB::FileHeader.property
    end

  end
end
