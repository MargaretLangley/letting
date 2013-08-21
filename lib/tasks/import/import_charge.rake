require 'csv'
require_relative '../../import/import'
require_relative '../../import/import_fields'
require_relative '../../import/import_charge'

STDOUT.sync = true

namespace :import do

  desc "Import clients data from CSV file"
  task charges: :environment do
    DB::ImportCharge.import DB::Import.csv_table('acc_info', \
     headers: DB::ImportFields.charge)
  end
end



