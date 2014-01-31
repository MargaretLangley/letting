# Drop, Create, Migrate, Test Prepare and then populate the development
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153

require 'optparse'

STDOUT.sync = true

namespace :db do

  desc "Imports lettings data from csv's generated by previous system."
  task :import, [:range, :test] => :environment do |task, args|

    options = parse_options args

    human_ref_range = Rangify.from_str(options[:range]).to_s

    # Stripped out for now but when in parellel with live system. nope
    Rake::Task['db:truncate_all'].execute
    Rake::Task['import:users'].invoke(options[:test])
    Rake::Task['import:clients'].execute
    Rake::Task['import:properties'].invoke(human_ref_range)
    Rake::Task['import:billing_profiles'].invoke(human_ref_range)
    Rake::Task['import:charges'].invoke(human_ref_range)
    Rake::Task['import:accounts'].invoke(human_ref_range)
    Rake::Task['import:update_charges'].invoke
    exit 0
  end

  def parse_options args
    options = {}
    OptionParser.new(args) do |opts|
      opts.banner = "Usage: rake db:import -- [options]"

      options[:range] = '1..9000'
      opts.on("-r", "--range {range}","Range of properties to import default is 1..9000.", String) do |range|
        options[:range] = range
      end

      options[:test] = false
      opts.on("-t", "--test","Generate dummy users with password 'password'", String) do
        options[:test] = true
      end

      opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
      end
    end.parse!
    options
  end
end