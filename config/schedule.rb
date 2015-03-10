# rubocop: disable Metrics/LineLength

set :output, '/var/log/syslog'
job_type :rbenv_rake, %{export PATH=~/.rbenv/shims:~/.rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && :environment_variable=:environment bundle exec rake :task --silent :output }

job_type :rbenv_runner, %{export PATH=~/.rbenv/shims:~/.rbenv/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && bundle exec rails runner -e :environment ':task' :output }

every 1.minute do
  rbenv_rake 'hide_monotonous_account_details'
  rbenv_runner 'Account.hide_monotonous_account_details'
end
