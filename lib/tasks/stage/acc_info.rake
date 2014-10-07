require_relative '../../stage/stage'

STDOUT.sync = true

namespace :db do
  namespace :stage do
    desc 'Improves legacy accounts/charge data quality by patching mistakes.'
    task :acc_info do
      Stage.new(file_name: 'import_data/staging/staging_acc_info.csv',
                input: acc_infos,
                instructions: [PatchAccInfo.new(patch: patch_acc_info),
                               InsertionAccInfo.new(insert: insert_acc_info)]
               ).stage
    end

    def acc_infos
      DB::CSVTransform.new file_name: 'import_data/legacy/acc_info.csv',
                           headers: DB::FileHeader.charge
    end

    def patch_acc_info
      DB::CSVTransform.new(file_name: 'import_data/patch/acc_info_patch.csv',
                           headers: DB::FileHeader.charge).to_a
    end

    def insert_acc_info
      DB::CSVTransform.new(file_name: 'import_data/patch/acc_info_deleted.csv',
                           headers: DB::FileHeader.charge).to_a
    end
  end
end
