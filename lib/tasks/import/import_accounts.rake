require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/accounts/import_account'

STDOUT.sync = true

namespace :db do
  namespace :import do

    desc 'Import accounting information from CSV file'
    task :accounts, [:range] => :environment do |_task, args|
      DB::ImportAccount.import staging_accounts,
                               range: Rangify.from_str(args.range).to_i
    end

    def staging_accounts
      DB::FileImport.to_a 'staging_acc_items',
                          headers: DB::FileHeader.account,
                          location: 'import_data/staging'
    end
  end
end
