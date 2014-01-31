[![Code Climate](https://codeclimate.com/github/BCS-io/letting.png)](https://codeclimate.com/github/BCS-io/letting)
[![Build Status](https://travis-ci.org/BCS-io/letting.png)](https://travis-ci.org/BCS-io/letting)
[![Coverage Status](https://coveralls.io/repos/BCS-io/letting/badge.png)](https://coveralls.io/r/BCS-io/letting)

Program for handling the accounts of a letting agency company in particular to print letters for people with unpaid charges.

Handles a number of properties with ground rents and other charges.

##GETTING STARTED

###Setup the Project

1. git clone git@github.com:BCS-io/letting.git
2. Rename database.example.yml => database.yml
3. Rename application.example.yml => application.yml. Within the file:
  1. Enter a SECRET_KEY_BASE or generate one using rake secret
  2. Enter database, username and password
4. bundle install
5. rake db:reboot - drops the database (if any), creates and runs migrations.
4. Either
  rake db:seed - to get a few lines to test with
  or
  rake db:import - to add the data from old system and bring it into this system. You need a copy of the CSV data files to import and have them in import_data off the root of the project.

##PRODUCTION

###Demo
http://letting.bcs.io

###My Reference Only
1. Webmachine alias: ssh arran

###Start From Scratch
1. cap deploy:setup
  1. Enter password for postgres database (from application.yml)
2. cap deploy
3. cap deploy:migrate
4. Add Data

###Add Data
Add data through either importing or seeding data

1. Imported Data
  To import data locally: rake db:import
  db:import has two options
  1. range:  rake 'db:import[1..200]'
  2. test passwords: rake 'db:import[test]'
    1. import creates an admin from the application.yml's user and password (see above).

  To import data on remote server:
  cap rake:invoke task=db:import

2. Seed Data
  1. cap deploy:seed

###Reset the database
Sometimes you have to reset the database. If this is the case follow this:
1. Remove any backend connections
  1. local dev: rake db:terminate RAILS_ENV=test
  2. Production: *need a cap version*
2. cap postgresql:drop_db
3. cap postgresql:drop_role
  1. role depends on db
4. Follow instructions 'Start from Scratch'

