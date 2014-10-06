require_relative '../../stage/stage'

STDOUT.sync = true

namespace :db do
  namespace :stage do
    desc 'Improves legacy accounts/charge data quality by patching mistakes.'
    task :acc_items do
      Stage.new(file_name: 'import_data/staging/staging_acc_items.csv',
                input: acc_items,
                patch: PatchAccItems.new(patch: patch_acc_items.to_a)).stage
    end

    def acc_items
      DB::CSVTransform.new file_name: 'import_data/legacy/acc_items.csv',
                           headers: DB::FileHeader.charge
    end

    def patch_acc_items
      DB::CSVTransform.new file_name: 'import_data/patch/acc_items_patch.csv',
                           headers: DB::FileHeader.charge
    end
  end
end
