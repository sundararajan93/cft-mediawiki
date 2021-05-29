#!/bin/bash

echo -e "Installing media wiki with Default DB Values...."
echo -e "Default Values"
echo -e "=============="


DBServer='sampleserver.ap-south-1.rds.amazonaws.com'
DBpass=$2
Password=$3
IPAddr='x.x.x.x'

echo -e "Installing MediaWiki...\n"

cd /var/lib/wiki
php maintenance/install.php --dbserver=$DBServer --dbname='wikidb' --dbuser='wikiuser' --dbpass='testpassword' --pass='testpassword' MediaWiki wiki && \
echo -e "Installed Mediawiki successfully"

echo -e "Configuring Public IP for Gridwiki" && \
sed -i 's/localhost/x.x.x.x/g' /var/www/html/wiki/LocalSettings.php && \
echo -e "Configured successfully."