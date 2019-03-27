#!/bin/bash

sudo apt-get install software-properties-common
sudo add-apt-repository universe -y
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update
sudo apt-get install certbot -y

certbot certonly --webroot  -n --agrees-to --email subham.singhal@zemosolabs.com  -w /usr/src/app/public -d lms.z-apps.io

if [ -d /etc/letsencrypt ]; then
    chown -R docker:docker /etc/letsencrypt
fi

if [ -d /var/lib/letsencrypt ]; then
    chown -R docker:docker /var/lib/letsencrypt
fi

if [ -d /var/log/letsencrypt ]; then
    chown -R docker:docker /var/log/letsencrypt
fi

touch /etc/logrotate.d/canvas

echo "/usr/src/app/log/*.log {
        weekly
        rotate 1
        missingok
        create 0644 docker docker
        notifempty
}" >> /etc/logrotate.d/canvas 

if [ -d /etc/letsencrypt/live ]; then
    rm /usr/src/nginx/nginx.conf
    mv /usr/src/app/nginx-conf/nginx.conf /usr/src/nginx/
    nginx -s reload
fi

su docker

crontab -l | { cat; echo "@monthly certbot renew"; } | crontab -




