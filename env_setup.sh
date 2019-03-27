#!/bin/bash

sudo apt-get install software-properties-common
sudo add-apt-repository universe -y
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update
sudo apt-get install certbot -y

chown -R docker:docker /usr/src/app/public
certbot certonly --webroot  -n --agree-tos --email < email > -w /usr/src/app/public -d < domain name>

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

echo "/usr/src/app/log/*.log { \n
        weekly \n
        rotate 1 \n
        missingok \n
        create 0644 docker docker \n
        notifempty \n
}" >> /etc/logrotate.d/canvas 

if [ -d /etc/letsencrypt/live ]; then
    rm /usr/src/nginx/nginx.conf
    mv /usr/src/app/nginx-conf/nginx.conf /usr/src/nginx/
    nginx -s reload
fi

su docker

crontab -l | { cat; echo "@monthly certbot renew"; } | crontab -




