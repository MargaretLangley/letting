require 'csv'
require_relative '../../import/import'
require_relative '../../import/import_client'

STDOUT.sync = true

namespace :import do

  def headers
    %w{human_id  title1  initials1 name1 title2  initials2 name2 flat_no  housename road_no  road  district  town  county  postcode}
  end


  desc "Import clients data from CSV file"
  task clients: :environment do
    DB::ImportClient.import DB::Import.csv_table('clients', headers: headers)
  end
end


