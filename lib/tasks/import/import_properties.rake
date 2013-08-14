require 'csv'
require_relative '../../import/import'
require_relative '../../import/import_property'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

namespace :import do

  def property_headers
    %w{human_id  updated title1  initials1 name1 title2  initials2 name2 flat_no  housename road_no  road  district  town  county  postcode}
  end

  def patch_headers
    %w{human_id  title1  initials1 name1 title2  initials2 name2 flat_no  housename road_no  road  district  town  county  postcode}
  end

  desc "Import properties data from CSV file"
  task  properties: :environment do
    DB::ImportProperty.import \
    DB::Import.csv_table('properties', headers: property_headers, drop_rows: 34)#, \
    # DB::Patch.import(Property, DB::Import.csv_table('properties_patch', headers: headers, location: 'import_data/patch'))
   end
end