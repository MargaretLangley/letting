# Drop, Create, Migrate, Test Prepare and then populate the development
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153

STDOUT.sync = true

namespace :db do

  desc "Inserting and deleting data can leave the automatic pk sequence out of step with your data. This fixes this difference."
  task reset_pk: :environment do
    ActiveRecord::Base.connection.reset_pk_sequence!(Address.table_name)
    ActiveRecord::Base.connection.reset_pk_sequence!(Block.table_name)
    ActiveRecord::Base.connection.reset_pk_sequence!(BillingProfile.table_name)
    ActiveRecord::Base.connection.reset_pk_sequence!(Client.table_name)
    ActiveRecord::Base.connection.reset_pk_sequence!(Entity.table_name)
    ActiveRecord::Base.connection.reset_pk_sequence!(Property.table_name)
  end

end