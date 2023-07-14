#!/bin/bash

docker tag docker-stack-web:latest c4software/damp-php-base:latest
docker push c4software/damp-php-base:latest