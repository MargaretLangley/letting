require_relative '../../import/update_charge'

STDOUT.sync = true

namespace :import do

  desc "Updates charges information"
  task :update_charges => :environment do
    DB::UpdateCharge.do
  end
end