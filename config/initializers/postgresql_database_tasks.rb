module ActiveRecord
  module Tasks
    ####
    #
    # PostgreSQLDatabaseTaks
    #
    # Terminating connections to the database when full access is
    # required - eg when upgrading the database.
    #
    # TODO: decide if we are using this code.
    #
    class PostgreSQLDatabaseTasks
      def drop
        establish_master_connection
        connection.select_all 'select ' \
                              'pg_terminate_backend(pg_stat_activity.pid) ' \
                              'from pg_stat_activity ' \
                              "where datname='#{configuration['database']}' " \
                              "AND state='idle';"
        connection.drop_database configuration['database']
      end
    end
  end
end
