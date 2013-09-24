# Drop, Create, Migrate, Test Prepare and then populate the development
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153

STDOUT.sync = true

namespace :db do

  desc "Inserting and deleting data can leave the automatic pk sequence out of step with your data. This fixes this difference."
  task reset_pk: :environment do
    ActiveRecord::Base.connection
                      .tables
                      .reject{|t| t == 'schema_migrations'}
                      .each do |table|
      ActiveRecord::Base.connection.reset_pk_sequence!(table)
    end
  end

end