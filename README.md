[![Code Climate](https://codeclimate.com/github/BCS-io/letting.png)](https://codeclimate.com/github/BCS-io/letting)
[![Build Status](https://travis-ci.org/BCS-io/letting.png)](https://travis-ci.org/BCS-io/letting)
[![Coverage Status](https://coveralls.io/repos/BCS-io/letting/badge.png)](https://coveralls.io/r/BCS-io/letting)

Program for handling the accounts of a letting agency company in particular to print letters for people with unpaid charges.

Handles a number of properties with ground rents and other charges.


Setup the Project

1. git clone git@github.com:BCS-io/letting.git
2. bundle install
3. rake db:reboot - drops the database (if any), creates and runs migrations.
4. Either
  rake db:seed - to get a few lines to test with
  or
  rake db:import - to add the data from old system and bring it into this system. You need a copy of the CSV data files to import and have them in import_data off the root of the project.

