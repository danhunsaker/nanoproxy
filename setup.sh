#!/bin/bash

cd $(dirname $0)

sudo -v

# Find dependencies
if which nanobox >/dev/null
then
  echo -n
elif which nanobox.exe >/dev/null
then
  ln -s $(which nanobox.exe) /usr/local/bin/nanobox
else
  echo "Nanobox not found. Install it and try again."
  exit
fi

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

echo "Installing configuration files..."
sudo cp -R ./nginx/* "${nginx_path}/"
sudo cp -R ./ssl/* "${ssl_path}/"
sudo sed -i s:"/etc/ssl":"${ssl_path}":g "${nginx_path}/nanobox.app"

echo "Generating root CA (base) certificate..."
sed 's/{DOMAIN}/CA/g' ${ssl_path}/nanobox/nanoapp.dev.cnf |
  sudo openssl req -x509 -days 3653 -newkey rsa:4096 \
  -batch -sha256 -nodes -config /dev/stdin \
  -keyout ${ssl_path}/nanobox/nanoapp-base.key \
  -out ${ssl_path}/nanobox/nanoapp-base.crt

echo "Installing script..."
sudo cp ./nanoproxy /usr/local/bin

echo "Installation complete!"
