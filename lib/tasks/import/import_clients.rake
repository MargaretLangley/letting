require 'csv'
require_relative '../../import/import'
require_relative '../../import/import_client'

STDOUT.sync = true

namespace :db do

  desc "Import clients data from CSV file"
  task import_clients: :environment do
    DB::ImportClient.import DB::Import.csv_table('clients')
  end
end


