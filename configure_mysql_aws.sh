#!/bin/bash

echo -e "Configuring MYSQL\n" && \
database=$1 && \
mysql --user=wikiuser --host=$database --password=password -e "CREATE database wikidb;" && \
mysql --user=wikiuser --host=$database --password=password -e "CREATE USER 'wiki'@'$database' IDENTIFIED BY 'password@123';" && \
mysql --user=wikiuser --host=$database --password=password -e "GRANT ALL PRIVILEGES ON wikidb.* TO 'wiki'@'$database' WITH GRANT OPTION;" && \
echo -e "Configuration completed"

#   aws rds describe-db-instances | grep Address | sed -e 's/^[[:space:]]*//' | awk '{print $2}' | cut -d "\"" -f 2