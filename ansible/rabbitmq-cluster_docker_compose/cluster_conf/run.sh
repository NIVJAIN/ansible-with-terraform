#!/bin/sh
set -e

if [ "$1" = "up" ];then
    echo "docker-compose up -d"
    docker-compose up -d
fi


if [ "$1" = "down" ];then
    echo "docker-compose up -d"
    docker-compose down
fi

if [ "$1" = "ps" ];then
    echo "docker-compose up -d"
    docker-compose ps -a
fi