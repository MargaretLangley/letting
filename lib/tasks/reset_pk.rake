# Each time a row is added to the database the PK is incremented
# However, with the seed/import this is not happending.
# At the end of the seed I go through all the tables and make sure the PK
# points to the next empty row!
#
STDOUT.sync = true

namespace :db do

  desc "Inserting and deleting data can leave the automatic pk sequence out of step with your data. This fixes this difference."
  task reset_pk: :environment do
    ActiveRecord::Base.connection
                      .tables
                      .reject { |t| t == 'schema_migrations'}
                      .each do |table|
      ActiveRecord::Base.connection.reset_pk_sequence!(table)
    end
  end

end