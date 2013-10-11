require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/import_fields'
require_relative '../../import/import_charge'

STDOUT.sync = true

namespace :import do

  desc "Import clients data from CSV file"
  task charges: :environment do
    DB::ImportCharge.import \
      DB::FileImport.to_a('acc_info', headers: DB::FileHeaders.charge)
  end
end



