require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_billing_profile'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

namespace :import do

  desc "Import billing profile addresses data from CSV file"
  task  billing_profiles: :environment do
    DB::ImportBillingProfile.import \
      DB::FileImport.to_a('address2', headers: DB::FileHeader.billing_profile),
        DB::Patch.import(BillingProfileWithId,
                         DB::FileImport.to_a('address2_patch', \
            headers: DB::FileHeader.billing_profile, location: 'import_data/patch'))
   end
end
