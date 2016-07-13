#!/bin/bash

# Stop a running instance of the MouseSOM Browser

docker ps | grep "db" > /dev/null
if [ $? -eq 0 ]; then
    echo "Stopping the database container..."
    docker stop db
else
    echo "Database container not running!"
fi

docker ps | grep "MouseSOM" >/dev/null
if [ $? -eq 0 ]; then
    echo "Stopping the MouseSOM Browser container..."
    docker stop MouseSOM
else
    echo "MouseSOM Browser container not running!"
fi
