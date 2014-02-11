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



===

####1. PROJECT SETUP

####1.1. Development Setup

1. `git clone git@github.com:BCS-io/letting.git`
2. Rename database.example.yml => database.yml
3. Rename application.example.yml => application.yml. Within the file:
  1. Enter a SECRET_KEY_BASE or generate one using rake secret
  2. Enter database, username and password
4. `bundle install`
5. `rake db:reboot` - drops the database (if any), creates and runs migrations.
4. Add Data
  Use either seed data or import production data
  4.1 Seed data: `rake db:seed`
  4.2 import data: `rake db:import`


===

####1.2. Production Setup

1. `cap deploy:setup`
  1. Enter password for postgres database (from application.yml)
2. `cap deploy`
3. `cap deploy:migrate`
4. Add Data
  Use either seed data or import production data
  .1 Seed data `cap deploy:seed`
  .2 Production data `cap rake:invoke task=db:import`

[Demo](http://letting.bcs.io)

My Reference: Webserver alias: `ssh arran`


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
Sometimes when you are changing a project the database will not allow you to delete it due to open connections to it. If you cannot close the connections you will have to reset the database. If this is the case follow this

1. Remove any backend connections
  1. local dev: `rake db:terminate RAILS_ENV=test`
  2. Production: *need a cap version*
2. `cap postgresql:drop_db`
3. `cap postgresql:drop_role`
  1. role depends on db
4. Follow instructions for: Project Setup

===
