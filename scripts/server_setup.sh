#!/usr/bin/env bash

# PRUN+Chef: Based on ubuntu: 16.04.1 LTS + SSHD(with authorize_key)

sudo apt-get -y update

## Ruby and dependencies

# Pre-requirements
sudo apt-get install -y git build-essential libsqlite3-dev libssl-dev gawk g++
sudo apt-get install -y libreadline6-dev libyaml-dev sqlite3 autoconf libgdbm-dev
sudo apt-get install -y libncurses5-dev automake libtool bison pkg-config libffi-dev

## Install ruby
sudo apt-get -y install software-properties-common
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update

sudo apt-get -y install ruby2.3 ruby2.3-dev

# Install prerequisites
echo gem --no-ri --no-rdoc | sudo tee -a /root/.gemrc
sudo gem install bundler
sudo gem install rack -v 1.6.0
sudo gem install thin -v 1.6.3
sudo thin install
sudo /usr/sbin/update-rc.d -f thin defaults

## Rails dependencies
sudo apt-get install -y imagemagick libmagickwand-dev

## Install postgres 9.5:
export LANGUAGE=en_US.UTF-8
sudo apt-get -y install postgresql libpq-dev

sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = 'localhost'/" /etc/postgresql/9.5/main/postgresql.conf
sudo sed -i "s/local   all             all                                     peer/local   all             all                                     md5/" /etc/postgresql/9.5/main/pg_hba.conf
sudo sed -i "s/ssl = true/ssl = false/" /etc/postgresql/9.5/main/postgresql.conf
sudo service postgresql restart

## Rewrite postgres password:
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

## Nginx: using vhost_wohhup.conf config file
sudo apt-get install -y nginx

sudo touch /etc/nginx/sites-available/vhost_minutehero.conf
sudo ln -s /etc/nginx/sites-available/vhost_minutehero.conf /etc/nginx/sites-enabled/vhost_minutehero.conf
sudo rm /etc/nginx/sites-enabled/default

sudo service nginx restart

# Nodejs/bower
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
nvm install node
npm install -g bower

## Capistrano
sudo mkdir /var/www/minutehero
sudo chown -R ubuntu:ubuntu /var/www/minutehero
#export RAILS_ENV="staging" ; bundle exec rake db:create

## init.d script
sudo thin config -C /etc/thin/minutehero.yml -c /var/www/minutehero/current -l log/thin.log -e staging --servers 1 --port 3000
sudo touch /etc/init.d/minutehero
sudo chmod a+x /etc/init.d/minutehero
sudo systemctl daemon-reload

## Create database: in failed deployment release folder
export RAILS_ENV="staging" ; bundle exec rake db:create

## Deploy
cap staging deploy
cap staging deploy:db_seed
