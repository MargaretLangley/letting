require_relative '../../stage/stage'

STDOUT.sync = true

namespace :db do
  namespace :stage do
    desc 'Improves legacy client data quality by patching inaccuracies.'
    task :address2 do
      Stage.new(file_name: 'import_data/staging/staging_address2.csv',
                input: address2,
                patch: PatchAddress2.new(patch: patch_address2.to_a)).stage
    end

    def address2
      DB::CSVTransform.new file_name: 'import_data/legacy/address2.csv',
                           headers: DB::FileHeader.agent
    end

    def patch_address2
      DB::CSVTransform.new file_name: 'import_data/patch/address2_patch.csv',
                           headers: DB::FileHeader.agent_patch
    end
  end
end
