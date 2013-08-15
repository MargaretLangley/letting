require 'csv'
require_relative '../../import/import'
require_relative '../../import/import_fields'
require_relative '../../import/import_billing_profile'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

namespace :import do

  desc "Import billing profile addresses data from CSV file"
  task  billing_profile: :environment do
    DB::ImportBillingProfile.import \
      DB::Import.csv_table('address2', headers: DB::ImportFields.billing_profile), \
        DB::Patch.import(BillingProfile, \
         DB::Import.csv_table('address2_patch', \
            headers: DB::ImportFields.billing_profile, location: 'import_data/patch'))
   end
end
