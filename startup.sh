#!/bin/bash

function get_free_port() {
  local start=$1
  local end=$2
  for ((i=start; i<=end; i++)); do
    nc -z localhost $i > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      echo $i
      return
    fi
  done
  echo 0
}

COMPOSE_FILE="./docker-compose.yml"
PROFILE="--profile default"

echo "Voulez-vous démarrer mongo ? (y/N)"
read -r mongo
if [[ "$mongo" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  PROFILE="--profile mongo $PROFILE"
fi

echo "Voulez-vous démarrer MailHog ? (y/N)"
read -r mailhog
if [[ "$mailhog" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  PROFILE="--profile mailhog $PROFILE"
fi

# Set environment variables
export DAMP_DB_PORT=""
export DAMP_WEB_PORT=""
export DAMP_PMA_PORT=""
export DAMP_MONGO_PORT=""
export DAMP_MAIL_PORT=""
export DAMP_MAIL_PORT_WEB=""
export DAMP_HOME_DIRECTORY="./"

# Stop containers
docker-compose -f $COMPOSE_FILE $PROFILE down

# Scan ports and select free ports
MYSQL_PORT=$(get_free_port 3306 3316)
HTTP_PORT=$(get_free_port 8080 8099)
PMA_PORT=$(get_free_port 9090 9099)
MONGO_PORT=$(get_free_port 27017 27027)
MAILHOG_PORT=$(get_free_port 1025 1035)
MAILHOG_PORT_WEB=$(get_free_port 8025 8035)

export DAMP_DB_PORT=$MYSQL_PORT
export DAMP_WEB_PORT=$HTTP_PORT
export DAMP_PMA_PORT=$PMA_PORT
export DAMP_MONGO_PORT=$MONGO_PORT
export DAMP_MAIL_PORT=$MAILHOG_PORT
export DAMP_MAIL_PORT_WEB=$MAILHOG_PORT_WEB
export DAMP_HOME_DIRECTORY="./"

# Start containers
docker compose -f $COMPOSE_FILE $PROFILE up -d

clear

echo "DAMP est démarré"
echo "MySQL : localhost:$MYSQL_PORT"
echo "HTTP / PHP : http://localhost:$HTTP_PORT"
echo "PhpMyAdmin : http://localhost:$PMA_PORT"
if [[ "$mongo" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  echo "MongoDB : localhost:$MONGO_PORT"
fi
if [[ "$mailhog" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  echo "MailHog : smtp://localhost:$MAILHOG_PORT / http://localhost:$MAILHOG_PORT_WEB"
fi

# Wait for user input
echo ""
read -p "Appuyer sur une touche pour quitter"

# Stop containers
docker compose -f $COMPOSE_FILE $PROFILE down
