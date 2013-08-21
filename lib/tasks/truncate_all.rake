# Drop, Create, Migrate, Test Prepare and then populate the development
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153

STDOUT.sync = true

namespace :db do

  desc "Truncates all the database tables"
  task truncate_all: :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE addresses RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE blocks RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE billing_profiles RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE charges RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE clients RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE due_ons RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE entities RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE properties RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE users RESTART IDENTITY;")
  end

end