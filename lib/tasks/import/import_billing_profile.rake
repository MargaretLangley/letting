require 'csv'
require_relative '../../import/import'
require_relative '../../import/import_billing_profile'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

namespace :import do

  def billing_profile_headers
    %w{human_id  title1  initials1 name1 title2  initials2 name2 flat_no  housename road_no  road  district  town  county  postcode}
  end

  desc "Import billing profile addresses data from CSV file"
  task  billing_profile: :environment do
    DB::ImportBillingProfile.import \
    DB::Import.csv_table('address2', headers: billing_profile_headers)
   end
end
