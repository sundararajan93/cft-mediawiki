#!/bin/bash

    echo -e "Configuring MYSQL\n" && \
    database='sampleserver.ap-south-1.rds.amazonaws.com' && \
    mysql --user=wikiuser --host=$database --password=password -e "CREATE database wikidb;" && \
    mysql --user=wikiuser --host=$database --password=password -e "CREATE USER 'wiki'@'$database' IDENTIFIED BY 'testpass';" && \
    mysql --user=wikiuser --host=$database --password=password -e "GRANT ALL PRIVILEGES ON wikidb.* TO 'wiki'@'$database' WITH GRANT OPTION;" && \
    echo -e "Configuration completed"
