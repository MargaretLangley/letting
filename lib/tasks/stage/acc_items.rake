require_relative '../../stage/stage'

STDOUT.sync = true

namespace :db do
  namespace :stage do
    desc 'Improves legacy accounts/charge data quality by patching mistakes.'
    task :acc_items do
      Stage.new(file_name: 'import_data/staging/staging_acc_items.csv',
                input: acc_items,
                instructions: [PatchAccItems.new(patch: patch_acc_items),
                               ExtractionAccItems.new(extracts: extract_acc_items),
                              ]
                ).stage
      # InsertionAccItems.new(insert: insert_acc_items)
    end

    def acc_items
      DB::CSVTransform.new file_name: 'import_data/legacy/acc_items.csv',
                           headers: DB::FileHeader.account
    end

    def patch_acc_items
      DB::CSVTransform.new(file_name: 'import_data/patch/acc_items_patch.csv',
                           headers: DB::FileHeader.account).to_a
    end

    def extract_acc_items
      DB::CSVTransform.new(file_name: 'import_data/patch/acc_items_extract.csv',
                           headers: DB::FileHeader.account).to_a
    end

    def insert_acc_items
      DB::CSVTransform.new(file_name: 'import_data/patch/acc_items_insert.csv',
                           headers: DB::FileHeader.account).to_a
    end
  end
end
