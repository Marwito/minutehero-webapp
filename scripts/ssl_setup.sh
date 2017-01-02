#!/usr/bin/env bash

## Install cert generator
cd /usr/local/sbin
sudo wget https://dl.eff.org/certbot-auto
sudo chmod a+x /usr/local/sbin/certbot-auto

## Create/verify certificates
mkdir /var/www/minutehero/current/public/.well-known
sudo certbot-auto certonly -a webroot --webroot-path=/var/www/minutehero/current/public -d staging.minutehero.net

## Generate Strong Diffie-Hellman Group
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

## Crontab entry for renewal
sudo crontab -e

30 2 * * 1 /usr/local/sbin/certbot-auto renew >> /var/log/le-renew.log
35 2 * * 1 /etc/init.d/nginx reload