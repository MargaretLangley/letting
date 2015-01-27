[![Code Climate](https://codeclimate.com/github/BCS-io/letting.png)](https://codeclimate.com/github/BCS-io/letting)
[![Build Status](https://travis-ci.org/BCS-io/letting.png)](https://travis-ci.org/BCS-io/letting)
[![Coverage Status](https://coveralls.io/repos/BCS-io/letting/badge.png)](https://coveralls.io/r/BCS-io/letting)
[![Dependency Status](https://gemnasium.com/BCS-io/letting.png)](https://gemnasium.com/BCS-io/letting)

###LETTING

Letting is an application for handling the accounts of a letting agency company in particular to print letters for people with unpaid charges. It handles a number of properties with ground rents, services, and other charges.

This document covers the following sections

####Content
1. Project Setup
  1. Development
  2. Production
2. Commands
  1. rake db:import
3. Troubleshooting
  1. Reset the database
  2. Running rails console in production
  3. Cheatsheet


===

####1. PROJECT SETUP

####1.1. Development Setup

1. `git clone git@github.com:BCS-io/letting.git`
2. sudo apt-get install libqt4-dev libqtwebkit-dev -y
  2.1 Required for Capybara-webkit
3. `bundle install --verbose`
  3.1 this can take a while and verbose gives feedback.
4. `rake db:create`
5. Clone the *private* repository into the import_data directory
  5.1 `git clone git@bitbucket.org:bcsltd/letting_import_data.git  ~/code/letting/import_data`
6. Create .env file - for data not kept in the repository
  6.1 `cp ~/code/letting/.env.example  .env`
  6.2 `rake secret`  and copy the generated key into .env

Repeat each time you want to delete and restore the database.

7. `rake db:reboot` - drops the database (if any), creates and runs migrations.
8. Add Data
  Use either seed data or import production data
  4.1 Seed data: `rake db:seed`
  4.2 import data: `rake db:import -- -t`
   4.2.1 -t includes test user and passwords.
9. Re-index Elasticsearch
   `rake elasticsearch:sync`

===

####1.2. Server Setup

1. `cap <environment> setup`
2. `cap <environment> env:upload`
  1. .env file uploaded to shared directory
3. `cap <environment> deploy`

4. Configure Elasticsearch memory limit (a memory greedy application)
   `sudo nano /usr/local/etc/elasticsearch/elasticsearch-env.sh`
   1. Change ES_HEAP_SIZE=1g, -Xms1g, -Xmx1g
  `sudo service elasticsearch restart`
  2. verify as it also says 'ok' when it fails.   `sudo service elasticsearch restart`

5. Add Data
  On your *local* system Add Data (see 1.1.6 above). Then copy to the server.
  `cap <environment> db:push`

6.  Import Data Into Elasticsearch Indexes
     `ssh <server>`
     `cd ~/apps/letting_<environment>/current`
     `bundle exec rails c production`
    `Property.import force: true, refresh: true`
    `Client.import force: true, refresh: true`
    `Payment.import force: true, refresh: true`
    or
    `rake elasticsearch:sync`



[Demo](http://letting.bcs.io)

My Reference: Webserver alias: `ssh arran`


####1.2. Cleaning Production Setup

1. `sudo rm -rf ~/apps/`
2. `sudo rm /tmp/unicorn.letting_*.sock`
3. `sudo -u postgres psql`
4. `postgres=# drop database letting_<environment>;`
4.1 if you have outstanding backend connections:
    `SELECT pid FROM pg_stat_activity where pid <> pg_backend_pid();`
    Then for each connection:
    `SELECT pg_terminate_backend($1);`
5. System can then have Production setup again

===

####2. COMMANDS

####2.1. rake db:import
  `rake db:import` is a command for importing production data from the old system to the new system.

  The basic command: `rake db:import`

#####options
  To add an option -- is needed after db:import to bypass the rake argument parsing.
  1. -r Range of properties to import: `rake db:import -- -r 1-200`
    1. Default is import all properties
  2. -t Adding test passwords for easy login: `rake db:import -- -t`
    1. Default is *no* test passwords
    2. Import creates an admin from the application.yml's user and password (see above).
  3. -h Help displays help and exits `rake db:import -- -h`


===

####3. TROUBLESHOOTING

####3.1. Reset the database
Sometimes when you are changing a project the database will not allow you to delete it due to open connections to it. If you cannot close the connections you will have to reset the database. If this is the case follow this:

1. `cap production rails:rake:db:drop`
2. If database will not be dropped - Remove any backend connections
  1. local dev: `rake db:terminate RAILS_ENV=test`
  2. Production: *need a cap version*
3. `cap <environment> deploy`
  1. Should see the migrations being run.
4. `cap <environment> db:push`
  1. The data has been deleted by the drop this puts it back.

####3.2 Running rails console in production
`bundle exec rails c production`

####3.3 Disabling the Firewall

If an operation is not completing and you suspect a firewall issue
these commands completely remove it. (Rebooting the box, if applicable, restores the firewall)
    sudo su
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -F

####3.4 Cheatsheet
1. change to Postgres user and open psql prompt `sudo -u postgres psql postgres`
2. Listing Users (roles) and attributes: `\du`
3. Listing all databases: `\list`
4. Connect to a database: `\c db_name`

===
