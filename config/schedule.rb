
set :output, '/var/log/syslog'

every 1.minute do
  command "echo 'Start !!!!: #{DateTime.now}'"
  runner  "Account.hide_monotonous_account_details"
  command "echo 'End !!!!: #{DateTime.now}'"
end
