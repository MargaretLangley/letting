require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/accounts/import_account'

STDOUT.sync = true

namespace :db do
  namespace :import do

    desc 'Import accounting information from CSV file'
    task :accounts, [:range] => :environment do |_task, args|
      DB::ImportAccount.import accounts_file,
                               range: Rangify.from_str(args.range).to_i
    end

    def accounts_file
      DB::FileImport.to_a 'acc_items',
                          headers: DB::FileHeader.account,
                          location: 'import_data/legacy'
    end
  end
end
