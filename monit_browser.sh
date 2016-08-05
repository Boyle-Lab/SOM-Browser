#!/bin/bash

# Start an instance of the MouseSOM Browser with monit

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

# Assumes monit is installed and monitrc is properly configured and
# present in /etc/monitrc
monit
