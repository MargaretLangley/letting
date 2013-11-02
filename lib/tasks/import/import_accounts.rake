require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_account'

STDOUT.sync = true

namespace :import do

  desc "Import accounting information from CSV file"
  task :accounts, [:range] => :environment do |task, args|
    range = Range.new(*args.range.split("..").map(&:to_i))
    DB::ImportAccount.import accounts_file, range: range
  end

  def accounts_file
    DB::FileImport.to_a 'acc_items', headers: DB::FileHeader.account
  end
end
