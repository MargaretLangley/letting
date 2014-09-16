# Drop, Create, Migrate, Test Prepare and then populate the development
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153

require 'optparse'

STDOUT.sync = true

namespace :db do

  desc "Imports lettings data from csv's generated by previous system."
  task :import, [:range, :test] => :environment do |_task, args|

    options = parse_options args

    human_ref_range = Rangify.from_str(options[:range]).to_s

    # Stripped out for now but when in parellel with live system. nope
    Rake::Task['db:truncate_all'].execute
    Rake::Task['db:import:users'].invoke(options[:test])
    Rake::Task['db:import:due_ons'].invoke
    Rake::Task['db:import:charge_cycle'].invoke(options[:test])
    Rake::Task['db:import:charged_ins'].invoke(options[:test])
    Rake::Task['db:import:sheet'].invoke
    Rake::Task['db:import:sheet_address'].invoke
    Rake::Task['db:import:clients'].execute
    Rake::Task['db:import:properties'].invoke(human_ref_range)
    Rake::Task['db:import:agents'].invoke(human_ref_range)
    Rake::Task['db:import:charges'].invoke(human_ref_range)
    Rake::Task['db:import:accounts'].invoke(human_ref_range)
    Rake::Task['db:import:update_charges'].invoke
    exit 0
  end

  # Do add to this method until refactored!
  # rubocop: disable  Metrics/LineLength
  # rubocop: disable  Metrics/MethodLength
  def parse_options args
    options = {}
    OptionParser.new(args) do |opts|
      opts.banner = 'Usage: rake db:import -- [options]'

      options[:range] = '1-9000'
      opts.on('-r', '--range {range}', 'Range of properties to import default: 1..9000.', String) do |range|
        options[:range] = range
      end

      options[:test] = false
      opts.on('-t', '--test', "Make users with password 'password'", String) do
        options[:test] = true
      end

      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end.parse!
    options
  end
end
