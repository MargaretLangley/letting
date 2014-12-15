STDOUT.sync = true

#
# Creates the files in the staging directory.
# Takes legacy/ data overwrites it with patch/ data when necessary.
# The result is put into the staging/ directory
#
namespace :db do
  desc 'Legacy data overwritten by patch data and saved in staging.'
  task stage: :environment do |_task, _args|
    include Logging
    logger.info 'db:stage:clients'
    Rake::Task['db:stage:clients'].invoke
    logger.info 'db:stage:properties'
    Rake::Task['db:stage:properties'].invoke
    logger.info 'db:stage:address2'
    Rake::Task['db:stage:address2'].invoke
    logger.info 'db:stage:acc_info'
    Rake::Task['db:stage:acc_info'].invoke
    logger.info 'db:stage:acc_items'
    Rake::Task['db:stage:acc_items'].invoke
  end
end
