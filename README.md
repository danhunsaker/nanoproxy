# nanoproxy
An HTTPS proxy configuration for [Nanobox](https://nanobox.io/) using [Nginx](https://nginx.org), [OpenSSL](https://www.openssl.org/), and a couple of management scripts

## Usage
These files are meant to be copied directly into place and then used by scripts to be committed later. May include a setup script to handle the copy step in a later commit.

For the moment, the `nginx/` directory should be merged into your existing Nginx configuration directory. The `ssl/` directory should similarly be merged into your SSL configuration directory.

_Note: If you're using Windows, also change the `/etc/ssl/` portions in `nginx/nanobox.app` to match the location of your SSL configuration directory._

## Reference
The commands which make up the majority of the upcoming scripts can be found [here](https://content.nanobox.io/testing-https-locally-with-nanobox/) (as soon as that article is published).
