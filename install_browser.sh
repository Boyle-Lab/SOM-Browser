#!/bin/bash

# This file will build and initialize the docker containers needed to
# run the SOM Browser. Edit the BROWSER_PATH variable to match the
# local directory holding the SOM Browser files before running.
BROWSER_PATH=/data/mouseENCODE.new/browser/MouseSOM

# Build the browser container image (Not necessary in most
# cases, since the image should pull directly from Docker Hub)
#docker build -t adadiehl/browser .

# Set up the database container
docker run -d --name db -e MYSQL_ROOT_PASSWORD=my-secret-pw -v $BROWSER_PATH/sql/:/data/sql mysql:5.7.13
docker run -it --link db -v $BROWSER_PATH/sql/:/data/sql --rm mysql sh -c 'exec mysql -h 172.18.0.2 -P 3306 -uroot -pmy-secret-pw </data/sql/MouseSOM.sql'
docker run -it --link db -v $BROWSER_PATH/sql/:/data/sql --rm mysql sh -c 'exec mysql -h 172.18.0.2 -P 3306 -uroot -pmy-secret-pw mousesom </data/sql/MouseSOM_DB_DATA.sql'
# Users.sql sets up the 'webuser' account and changes the root password. The
# root password defaults to 'CHANGE_ME'. You should change this to something
# more secure!
docker run -it --link db -v $BROWSER_PATH/sql/:/data/sql --rm mysql sh -c 'exec mysql -h 172.18.0.2 -P 3306 -uroot -pmy-secret-pw mousesom </data/sql/Users.sql'

# Set up the browser container. -p 3000:3000 is for the test browser: MouseSOM/script/mousesom_server.pl
# -p 5000:80 is for the production server. Change the outward-facing port (5000) to match your local
# configuration.
docker run -t --name="MouseSOM" --link db -v $BROWSER_PATH/:/var/www/MouseSOM/ -d -p 3000:3000 -p 5000:80 adadiehl/browser
