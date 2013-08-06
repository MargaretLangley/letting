# Drop, Create, Migrate, Test Prepare and then populate the development
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153

STDOUT.sync = true

namespace :db do

  desc "Raise an error unless development environment"
  task :dev_warning do
    raise "You should only perform this task in development." unless Rails.env == 'development'
  end

  desc "Get app databases back to base state: db:drop, db:create, db:migrate, db:test:prepare, db:populate"
  task reboot: [
    'environment',
    'db:dev_warning',
    'db:drop',
    'db:create',
    'db:migrate',
    # db:import If after test prepare it seeds test database
    'db:test:prepare'
  ]

end