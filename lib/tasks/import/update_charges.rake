require_relative '../../import/update_charge'

STDOUT.sync = true

####
#
# update_charges.rake
#
# Runs after charges and accounts (debits) have been loaded
# it generates start and, if finished, end dates for
# an accounts charge.
#
####
namespace :db do
  namespace :import do
    desc "Updates charges information"
    task :update_charges => :environment do
      DB::UpdateCharge.do
    end
  end
end