MinuteHero WWW
================
These instructions should work on Ubuntu 14 and 16.

This application requires:

- Ruby 2.3.3
- Rails 5.0.1

Setting up the development environment
--------------------------------------

### Install RVM

* \curl -sSL https://raw.githubusercontent.com/wayneeseguin/rvm/stable/binscripts/rvm-installer | sudo bash -s stable
* source ~/.rvm/scripts/rvm # to be added to .bashrc
* type rvm | head -n 1 # to confirm that rvm is loaded as a function. It should output "rvm is a function". If it shows anything else, rvm isn't loading correctly.
* rvm install 2.3.3

* sudo usermod -a -G rvm $USER

### Install NVM

* sudo apt-get install build-essential checkinstall
* sudo apt-get install libssl-dev
* curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
* nvm install 6.0

### Install bower

* sudo npm install -g bower

### Install bundler

* gem install bundler
* bundle install

### Install Postgres on Ubuntu 14.04

* for other Ubuntu versions : https://askubuntu.com/questions/831292/how-to-install-postgresql-9-6-on-any-ubuntu-version

* sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"
* wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
* sudo apt-get update
* sudo apt-get install postgresql-9.6
* sudo apt install libpq-dev
* sudo -u postgres psql 
* \password # to change your password
* Enter new password: # type postgres
* Enter it again: # confirmation
* \q # to quit psql

In case postgres wouldn't start, execute these commands :

* systemctl status postgresql # If PostgreSQL is running, you'll see output that includes the text Active: active (exited).
If you see Active: inactive (dead), start the PostgreSQL service using the following command:

* systemctl start postgresql

PostgreSQL also needs to be enabled to start on reboot. Do that with this command:

* systemctl enable postgresql

### Install phantomjs

* sudo apt install phantomjs # Needed to run the automated regression tests using rspec

### Email notification configuration

We use AWS SES to receive email notifications from the app.

1. Install AWS SDK for Ruby : gem install aws-sdk

2. Get your AWS credentials and save them respectively in the variables:
   AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in the file
   'config/application.yml'

3. You can edit the email addresses you want to receive notifications for using the variable 'send_call_notifications_to_email' in the file 'config/application.yml' too. 

4. Verify these email addresses with Amazon SES.

### Setup of the database

* rake db:drop # only if you already have an existing database
* rake db:create
* rake db:migrate
* rake db:seed

### Starting the web server by default

* guard

### Admin account by default: 
* admin_email: admin@minutehero.net
* admin_password: minher0!

Documentation and Support
-------------------------

Services:
* Newrelic: ops@minutehero.net / az3e5ta?

Issues
-------------

Similar Projects
----------------

Contributing
------------

Credits
-------

License
-------
