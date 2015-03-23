[![Code Climate](https://codeclimate.com/github/BCS-io/letting.png)](https://codeclimate.com/github/BCS-io/letting)
[![Build Status](https://travis-ci.org/BCS-io/letting.png)](https://travis-ci.org/BCS-io/letting)
[![Coverage Status](https://coveralls.io/repos/BCS-io/letting/badge.png)](https://coveralls.io/r/BCS-io/letting)
[![Dependency Status](https://gemnasium.com/BCS-io/letting.png)](https://gemnasium.com/BCS-io/letting)

###LETTING

Letting is an application for handling the accounts of a letting agency company in particular to print letters for people with unpaid charges. It handles a number of properties with ground rents, services, and other charges.

This document covers the following sections

####Content
1. Project Setup
  1. Development Setup
  2. Server Setup
    1. Install Ubuntu Linux 14.04 LTS
    2. Deploy the Software stack using Chef
    3. Deploy the application
2. Commands
  1. rake db:import
3. Cheatsheet
  1. SSH
  2. Firewalls
    .1 Listing Firewall
    .2 Adding Ranges to the firewall
    .3 Disabling the Firewall
  3. Chef
  4. Postgresql
  5. Elasticsearch
  6. QEMU
    5.1 Basic Commands
    5.2 Removing an instance from
4. Troubleshooting
  1. Net::SSH::HostKeyMismatch
  2. Running Rake Tasks on Production Server
  3. Cleaning Production Setup
  4. Reset the database
  5. Running rails console in production
  6. Capistrano failing to deploy - with github.com port-22
  7. Truncating a file without changing ownership
5. Production Client


===

###1. PROJECT SETUP

####1.1. Development Setup

1. `git clone git@github.com:BCS-io/letting.git`
2. sudo apt-get install liƒbqt4-dev libqtwebkit-dev -y
  1. Required for Capybara-webkit
3. `bundle install --verbose`
  1. this can take a while and verbose gives feedback.
4. `rake db:create`
5. Clone the *private* repository into the import_data directory
  1. `git clone git@bitbucket.org:bcsltd/letting_import_data.git  ~/code/letting/import_data`
6. Create .env file - for data not kept in the repository
  1. `cp ~/code/letting/.env.example  .env`
  2. `rake secret`  and copy the generated key into .env

Repeat each time you want to delete and restore the database.

7. `rake db:reboot` - drops the database (if any), creates and runs migrations.
8. Add Data
  Use either seed data or import production data
  1. Seed data: `rake db:seed`
  2. import data: `rake db:import -- -t`
    .1 -t includes test user and passwords.
9. Re-index Elasticsearch
   `rake elasticsearch:sync`


####1.2. Server Setup

1. Install Ubuntu Linux 14.04 LTS

2. Deploy the Software stack using Chef
  1. `cd ~/code/chef/repo`
  2. `knife solo bootstrap root@example.com'
    1. Once complete reboot box before webserver working
    2. Once System set up use `knife solo cook deployer@example.com' for further updates.

3. Deploy the application
  1. `cap <environment> setup`
  2. `cap <environment> env:upload`
    1. .env file uploaded to shared directory
  3. `cap <environment> deploy`

  4. Configure Elasticsearch memory limit (a memory greedy application)
     `sudo nano /usr/local/etc/elasticsearch/elasticsearch-env.sh`
    1. Change: ES_HEAP_SIZE=1503m  => ES_HEAP_SIZE=1g, -Xms1g, -Xmx1g
    `sudo service elasticsearch restart`
    2. verify as it also says 'ok' when it fails.   `sudo service elasticsearch restart`

  5. Add Data
    On your *local* system Add Data (see 1.1.6 above). Then copy to the server.
    `cap <environment> db:push`
    or `cap internet rails:rake:db:seed`

  6. Import Data Into Elasticsearch Indexes
    `cap <environment> 'invoke[elasticsearch:sync]'`


My Reference: Webserver alias: `ssh arran`

===

###2. COMMANDS

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


###3 Cheatsheet

####3.1 SSH

1. brew install ssh-copy-id
2. ssh-copy-id deployer@example.com
3. ssh deployer@example.com  (verify)

####3.2 Firewall

#####3.2.1 Listing Firewall

`sudo iptables --list`

#####3.1.2 Adding Ranges to the wall

1. ssh to the server which is having packets blocked.
2. What address is being blocked? `cat /var/log/kern.log`
  1. The logs contains blocked ip packets - to summarize the import things. DST is the ip address of the server we have been blocked to getting and DPT is the port number. We want to allow this combination through.
  Mar 13 ... iptables denied: IN= OUT=eth0 ... DST=23.23.181.189 ... DPT=443
3. What range does the blocked ip address belong to?
  1. Install whois if not already installed
  2. whois 23.23.181.189
  3. Add the CIDR range to the firewall, in this case Amazon's 23.20.0.0/14

#####3.2.3 Disabling the Firewall

If an operation is not completing and you suspect a firewall issue
these commands completely remove it. (Rebooting the box, if applicable, restores the firewall)

````
    sudo su
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -F
````

#####3.3 Chef

######3.3.1 Updating a cookbook

1. Clone the cookbook to the local machine under ~/code/chef/
2. Make changes to the cookbook increment the version in the meta data and commit and push back.
3. Under the repo directory update the reference `berks update <cookbook-name>`
  1. Confirm the version number has changed to the one you used in 2.
4. Update the cookbook by revendoring `berks vendor ./cookbooks/`
5. Apply the cookbook again: `knife solo bootstrap deployer@example.com`
  1. Don't bother around 5 - 11 pm in the evening as you get failed to connect.


######3.3.2 Updating a server

Chef is installed on servers - I've seen this get out of date. Removing it and then doing a knife solo bootstrap puts on a later version. Running chef on existing server may have firewall problems.

1. Confirm situation: `dpkg --list | grep chef` and `sudo find / -name chef`
2. Remove package: `sudo apt-get purge chef`
3. Run chef again: `knife solo bootstrap root@example.com`
4. Step 1 confirm situation.


#####3.4 Postgresql
1. change to Postgres user and open psql prompt `sudo -u postgres psql postgres`
2. Listing Users (roles) and attributes: `\du`
3. Listing all databases: `\list`
4. Connect to a database: `\c db_name`
5. Execute SQL file:  `psql -f thefile.sql letting_<envionrment>`
6. Logging In: `psql -d letting_<envionment> -U letting_<environment>`

#####3.5 Elasticsearch

1) Forced Re-index:   `rake elasticsearch:sync` <br>
2) Find Cluster name: `curl -XGET 'http://localhost:9200/_nodes'`  <br>
3) Document Mapping:  `curl -XGET "localhost:9200/development_properties/_mapping?pretty=true"`  <br>
4) Find All indexes:   `curl -XGET "localhost:9200/_stats/indices?pretty=true"`  <br>
                       example: development_properties<br>
5) Index Structure:    `curl -XGET 'http://127.0.0.1:9200/my_index/_mapping?pretty=1'` <br>
6) Return Records:     `curl -XGET "localhost:9200/my_index/_search?pretty=true"`  <br>
7) 'Simple' Query

````
    GET development_properties/_search
    {
       "query": {
          "match": {
              "_all": {
                  "query": "35 Beau",
                  "operator": "and"
              }
          }
       }
    }
````

When Elasticsearch Breaks the build during testing:

````
   Failure/Error: Client.import force: true, refresh: true
       Faraday::ConnectionFailed:
         Connection refused - connect(2) for "localhost" port 9200
````

Reset Elasticsearch

````
sudo service elasticsearch restart
````

Somtimes it won't delete the Elasticsearch pid file.

````
    Stopping elasticsearch...PID file found, but no matching process running?
    Removing PID file...
    rm: cannot remove ‘/usr/local/var/run/10_0_0_101.pid’: Permission denied

    To Remove
    sudo rm /usr/local/var/run/10_0_0_101.pid

    Repeat Restart

````

#####3.6 QEMU

######3.6.1 Basic Commands

````
virsh list --all     -  List running virtual servers

virsh reboot <vm-name>  - restarts the virtual server
virsh shutdown <vm-name> - quit of virtual server
virsh destroy <vm-name> - forced quit of virtual server

virsh start <vm-name> - start guest
````

######3.6.2 Displaying Logical Volume

`lvdisplay -v /dev/<volume-group-name>`
* `lvdisplay -v /dev/fla2014-vg`

######3.6.3 Removing an instance from

Removing an instance called <vm-name>

`````
  virsh destroy <vm-name>

  lvremove /dev/<volume-group-name>/<vm-name> -f
    * lvremove /dev/fla-2014/papa -f

  virsh undefine <vm-name>
  rm -rf /var/lib/libvirt/images/<vm-name>
  sudo reboot - otherwise temporary files prevent you from reusing the vm name
`````

######3.6.4 Creating an instance from

Removing an instance called <vm-name>

`````
  sudo su
  mkdir -p /var/lib/libvirt/images/<vm-name>
  nano builder_script
  Insert builder script (Scripts saved in repository: bcs-network under: /configs/vm)
  chmod +x builder_script
`````

Creating the diskspace - 7GB Root(/), 3GB Swap, 9GB /var

````
cat > vmbuilder.partition  <<EOF
root 7000
swap 3000
/var 9000
EOF
````

Run the builder script

`./builder_script`

Edit the product of the builder script

`nano /etc/libvirt/qemu/<vm-name>.xml`

Changing

1. Driver from 'qcow2' to 'raw'   (a => b)
  a. <driver name='qemu' type='qcow2'/>
  b. <driver name='qemu' type='raw'/>

2. source file from qcow's to vm-name (a => b)
  a. <source file='/var/lib/libvirt/images/scarp/ubuntu-kvm/tmpd6ojfe.qcow2'/>
  b. <source file='/dev/<volume-group-name>/<vm-name>'>
    1. <source file='/dev/fla2014-vg/scarp'


Create the logical volume

`lvcreate -L 20G --name <vm-name> <volume-group-name>`
 1. `lvcreate -L 20G --name scarp fla2014-vg`

Conversion

`qemu­-img convert /var/lib/libvirt/images/<vm-name>/ubuntu-kvm/tmp???????.qcow2 ­-O raw /dev/<volume-group-name>/<vm-name>`

Configuration
`virsh autostart <vm-name>`
`virsh start <vm-name>`

Verify
`ping 10.0.0.X`
`ssh deployer@10.0.0.x`
  `ping 8.8.8.8`

===

###4. TROUBLESHOOTING

####4.1 Net::SSH::HostKeyMismatch

Error seen as something like:

fingerprint d2:82:b0:34:3c:df etc does not match for "193.183.99.251" Copy the workstation public key to the server.

Problem:
Computers keep a unique identifier of servers they have connected with so that they can prevent a bad actor pretending they are that server. However, sometimes the ID of the server changes in which case you need to reset the server.

Solution

`ssh-keygen -R <ip address> | <name>`


####4.2 Missing secret_key_base

Without the secret_key being set - nothing works 2 diagnostics:
1. cat unicorn.stderr.log - app error: Missing `secret_key_base` ... set this value in `config/secrets.yml
2. current/.env is missing
3. Do not add the file into version control, git.

Solution

1. run `rake secret` and copy the output
2. Create a .env file in the root of the project
3. Add SECRET_KEY_BASE:  and copy the output from 1.
4. `cap production env:upload`
5. Restart the server - another deployment did this otherwise `sudo service unicorn_<name of process> reload` worth trying.


####4.2 Running Rake Tasks on Production Server

  `ssh <server>`
  `cd ~/apps/letting_<environment>/current`
  ` RAILS_ENV=<environment> bundle exec rake <method name>`


####4.3. Cleaning Production Setup

1. `sudo rm -rf ~/apps/`
2. `sudo rm /tmp/unicorn.letting_*.sock`
3. `sudo -u postgres psql`
4. `postgres=# drop database letting_<environment>;`
  1. if you have outstanding backend connections:
    `SELECT pid FROM pg_stat_activity where pid <> pg_backend_pid();`
    Then for each connection:
    `SELECT pg_terminate_backend($1);`
5. Start Server Setup

===


####4.4. Reset the database
Sometimes when you are changing a project the database will not allow you to delete it due to open connections to it. If you cannot close the connections you will have to reset the database. If this is the case follow this:

1. `cap production rails:rake:db:drop`
2. If database will not be dropped - Remove any backend connections
  1. local dev: `rake db:terminate RAILS_ENV=test`
  2. Production: *need a cap version*
3. `cap <environment> deploy`
  1. Should see the migrations being run.
4. `cap <environment> db:push`
  1. The data has been deleted by the drop this puts it back.

####4.5 Running rails console in production
`bundle exec rails c production`

####4.6 Capistrano failing to deploy - with github.com port-22

Occasionally a deployment fails with an unable to connect to github.
Any network service is not completely reliable. Wait for a while and try again.

````
DEBUG [44051a0f]  ssh: connect to host github.com port 22: Connection timed out
DEBUG [44051a0f]  fatal: Could not read from remote repository.
````

####4.7 Truncating a file without changing ownership

````
cat /dev/null > /file/you/want/to/wipe-out
`````


####5 Production Client
On release of the version go through the checklist in docs/production_checklist