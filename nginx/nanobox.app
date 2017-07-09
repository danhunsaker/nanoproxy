server {
  listen 80;
  listen 443 ssl;
  server_name {DOMAIN} *.{DOMAIN};

  ssl_certificate     /etc/ssl/nanobox/{DOMAIN}.crt;
  ssl_certificate_key /etc/ssl/nanobox/{DOMAIN}.key;

  location / {
    proxy_pass http://{TARGET};
  }
}
