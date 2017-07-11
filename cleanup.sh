#!/bin/bash

sudo -v

# Find dependencies
if which nginx >/dev/null
then
  echo -n
else
  echo "Nginx not found. Install it and try again."
  exit
fi

if which openssl >/dev/null
then
  echo -n
else
  echo "OpenSSL not found. Install it and try again."
  exit
fi

nginx_path="$(dirname $(nginx -V |& sed 's: :\n:g' | grep conf-path | sed 's/.*conf-path=//') 2>/dev/null)"
ssl_path=/etc/ssl

while [ ! "$(readlink -en "${nginx_path}")" ]
do
  read -ep "Nginx configuration path not found; Enter it here: " -i "${nginx_path}" nginx_path
  nginx_path="$(readlink -en "${nginx_path}")"
done

while [ ! "$(readlink -en "${ssl_path}")" ]
do
  read -ep "SSL configuration path not found; Enter it here: " -i "${ssl_path}" ssl_path
  ssl_path="$(readlink -en "${ssl_path}")"
done

echo "Removing nanoproxy local HTTPS for Nanobox..."
sudo rm ${nginx_path}/conf.d/nanobox.conf
sudo rm ${nginx_path}/nanobox.app
sudo rm -r ${nginx_path}/nanobox
sudo rm -r ${ssl_path}/nanobox
sudo nginx -s reload

sudo rm /usr/local/bin/nanoproxy

echo "Done. Nanoproxy will no longer handle requests for your Nanobox apps."
echo "Be sure to clean out your /etc/hosts file."
