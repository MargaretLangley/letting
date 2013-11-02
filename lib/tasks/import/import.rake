# Drop, Create, Migrate, Test Prepare and then populate the development
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153

STDOUT.sync = true

namespace :db do

  desc "Imports lettings data from csv's generated by previous system."
  task :import, [:range] => :environment do |task, args|

    # Stripped out for now but when in parellell with live system. nope
    Rake::Task['db:truncate_all'].execute
    Rake::Task['import:users'].execute
    Rake::Task['import:clients'].execute
    Rake::Task['import:properties'].invoke(args.range)
    Rake::Task['import:billing_profiles'].invoke(args.range)
    Rake::Task['import:charges'].invoke(args.range)
    Rake::Task['import:accounts'].invoke(args.range)
  end
end