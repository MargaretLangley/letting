require 'csv'
require_relative '../import/import'
require_relative '../import/import_billing_profile'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

namespace :db do

  desc "Import billing profile addresses data from CSV file"
  task  import_billing_profile: :environment do
    DB::ImportBilling.import DB::Import.csv_table('address2')
   end
end
