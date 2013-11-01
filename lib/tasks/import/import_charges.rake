require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_charge'

STDOUT.sync = true

namespace :import do

  desc "Import clients data from CSV file"
  task :charges, [:range] => :environment do |task, args|
    range = Range.new(*args.range.split("..").map(&:to_i))
    DB::ImportCharge.import charges_file, range: range
  end

  def charges_file
    DB::FileImport.to_a 'acc_info', headers: DB::FileHeader.charge
  end
end



