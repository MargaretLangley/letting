[![Code Climate](https://codeclimate.com/github/BCS-io/letting.png)](https://codeclimate.com/github/BCS-io/letting)
[![Build Status](https://travis-ci.org/BCS-io/letting.png)](https://travis-ci.org/BCS-io/letting)
[![Coverage Status](https://coveralls.io/repos/BCS-io/letting/badge.png)](https://coveralls.io/r/BCS-io/letting)

Program for handling the accounts of a letting agency company in particular to print letters for people with unpaid charges.

Handles a number of properties with ground rents and other charges.

##GETTING STARTED

###Setup the Project

1. git clone git@github.com:BCS-io/letting.git
2. Rename database.example.yml => database.yml
   2.1. enter database, username and password into production group
3. Rename application.example.yml => application.yml
   3.1. enter a SECRET_KEY_BASE or generate one using rake secret
4. bundle install
5. rake db:reboot - drops the database (if any), creates and runs migrations.
4. Either
  rake db:seed - to get a few lines to test with
  or
  rake db:import - to add the data from old system and bring it into this system. You need a copy of the CSV data files to import and have them in import_data off the root of the project.

##PRODUCTION

###My Reference Only
1. Webmachine alias: ssh arran

###Start From Scratch
1. cap deploy:setup
1. 1. Enter password for postgres database
2. cap deploy
3. cap deploy:migrate

###Reset the database
1. cap postgresql:drop_db
2. cap postgresql:drop_role   (role depends on db)
Then follow Start from Scratch


###Imported Data
1. cap rake:invoke task=db:import
2. Use the admin created from the application.yml's user and password (see above).

###Seed Data
1. cap deploy:seed

