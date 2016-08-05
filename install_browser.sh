#!/bin/bash

# This file will build and initialize the docker containers needed to
# run the SOM Browser. Edit the BROWSER_PATH variable to match the
# local directory holding the SOM Browser files before running.
BROWSER_PATH=/data/mouseENCODE.new/browser/MouseSOM

# Build the browser container image (Not necessary in most
# cases, since the image should pull directly from Docker Hub)
#docker build -t adadiehl/browser .

# Set up the database container
echo "Unzipping datafiles..."
WD=$(pwd)
cd MouseSOM/sql
tar -xzf sql_data.tgz
cd $WD
echo "Setting up database container..."
docker run -d --name db -e MYSQL_ROOT_PASSWORD=my-secret-pw -v $BROWSER_PATH/sql/:/data/sql --restart unless-stopped mysql:5.7.13

# Set up the browser container. -p 3000:3000 is for the test browser: MouseSOM/script/mousesom_server.pl
# -p 5000:80 is for the production server. Change the outward-facing port (5000) to match your local
# configuration.
echo "Setting up MouseSOM Browser container..."
docker run -t --name="MouseSOM" --link db -v $BROWSER_PATH/:/var/www/MouseSOM/ -d -p 3000:3000 -p 5000:80 --restart unless-stopped adadiehl/browser
docker exec -i MouseSOM sh -c 'cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig'
docker exec -i MouseSOM sh -c 'cat > /etc/nginx/nginx.conf' <nginx.conf

# The following should not be necessary for most applications.
#docker exec -i MouseSOM sh -c 'cp /etc/nginx/fastcgi_params /etc/nginx/fastcgi_params.orig'
#docker exec -i MouseSOM sh -c 'cat > /etc/nginx/fastcgi_params' <fastcgi_params

# Optional: set up monit process monitor to keep browser services running
docker exec -i MouseSOM sh -c 'cat > /etc/monitrc' <monitrc
docker exec -i MouseSOM sh -c 'chmod 0700 /etc/monitrc'

# Load the database data
docker run -it --link db -v $BROWSER_PATH/sql/:/data/sql --rm mysql sh -c 'exec mysql -h 172.18.0.2 -P 3306 -uroot -pmy-secret-pw </data/sql/MouseSOM.sql'
docker run -it --link db -v $BROWSER_PATH/sql/:/data/sql --rm mysql sh -c 'exec mysql -h 172.18.0.2 -P 3306 -uroot -pmy-secret-pw mousesom </data/sql/MouseSOM_DB_DATA.sql'
# Users.sql sets up the 'webuser' account and changes the root password. The
# root password defaults to 'CHANGE_ME'. You should change this to something
# more secure!
docker run -it --link db -v $BROWSER_PATH/sql/:/data/sql --rm mysql sh -c 'exec mysql -h 172.18.0.2 -P 3306 -uroot -pmy-secret-pw mousesom </data/sql/Users.sql'


echo "Done!"
