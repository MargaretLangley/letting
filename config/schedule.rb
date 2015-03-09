
set :output, '/var/log/syslog'

every 1.minute do
  # runner "Account.balance_all"
  # {AccountDetails.balanced.map { |ad| ad.account.id }}
  #command "Echo *********:"
end
