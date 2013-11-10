require_relative '../data_diagnostic/debtors'
require_relative '../modules/rangify'

STDOUT.sync = true

desc 'List out the debtors'
task :debtors, [:range] => :environment do |task, args|
  args.with_defaults(range: '1..8000')
  Debtors.go Rangify.from_str(args.range).to_i
end