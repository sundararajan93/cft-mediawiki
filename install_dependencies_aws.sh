#!/bin/bash

echo -e "Installing PHP 8.0 along with MYSQL \n"

add-apt-repository -y ppa:ondrej/php && \
apt-get update -y && \
apt-get install -y apache2 mysql-server php8.0 libapache2-mod-php8.0 php8.0-mysql php8.0-mcrypt php8.0-fpm php8.0-mbstring php8.0-apcu php-xml php-intl && \
echo -e "Restarting APACHE\n" && \
systemctl restart apache2 && \
echo -e "Downloading and Installing MediaWiki from sources\n" && \
wget https://releases.wikimedia.org/mediawiki/1.35/mediawiki-1.35.2.tar.gz && \
tar xvzf mediawiki-1.35.2.tar.gz && \
mv mediawiki-1.35.2 /var/lib/wiki && \
cd /var/www/html/ && \
ln -s /var/lib/wiki wiki && \
systemctl restart apache2 && \


echo -e "Installation Complete"
