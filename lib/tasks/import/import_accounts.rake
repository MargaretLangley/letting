require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_account'

STDOUT.sync = true

namespace :import do

  desc "Import accounting information from CSV file"
  task accounts: :environment do
    DB::ImportAccount.import accounts_file
  end

  def accounts_file
    DB::FileImport.to_a 'acc_items_trial', headers: DB::FileHeader.account
  end
end
