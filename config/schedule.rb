
set :output, '/var/log/syslog'

every 1.minute do
  # runner "Account.balance_all"
  command "echo 'Changed it for test'"
end
