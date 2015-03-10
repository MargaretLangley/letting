desc 'cron task for hiding old account transactions that are balancing'
task hide_monotonous_account_details: :environment do
  puts 'Monotonous'
  Account.hide_monotonous_account_details
end
