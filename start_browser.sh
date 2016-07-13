#!/bin/bash

# Start an instance of the MouseSOM Browser

docker ps | grep "db" > /dev/null
if [ $? -eq 1 ]; then
    echo "Starting the database container..."
    docker start db
else
    echo "Database container already running!"
fi

docker ps | grep "MouseSOM" >/dev/null
if [ $? -eq 1 ]; then
    echo "Starting the MouseSOM Browser container..."
    docker start MouseSOM
else
    echo "MouseSOM Browser container already running!"
fi

docker exec MouseSOM ps -ef | grep "fcgi" > /dev/null
FS=$?
docker exec MouseSOM ps -ef | grep "nginx" > /dev/null
SS=$?

if [ $SS -eq 1 ] && [ $FS -eq 1 ]; then
    echo "Starting nginx and fastcgi.."
    docker exec MouseSOM browser_up.sh
elif [ $SS -eq 1 ]; then
    echo "Starting nginx"
    docker exec service nginx start
elif [ $FS -eq 1 ]; then
    echo "Starting fastcgi"
    docker exec service fastcgi start
else
    echo "Server and fastcgi already running!"
fi
