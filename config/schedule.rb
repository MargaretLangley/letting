
set :output, '/var/log/syslog'

every 1.minute do
  # runner "Account.balance_all"
  command "echo 'you can use raw cron syntax too'"
end
