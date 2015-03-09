
set :output, '/var/log/syslog'

every 1.minute do
  command "Start *********: #{DateTime.now}"
  runner  "Account.hide_monotonous_account_details"
  command "End *********: #{DateTime.now}"
end
