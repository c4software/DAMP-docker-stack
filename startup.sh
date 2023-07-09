#!/bin/bash

source simple_curses.sh

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

readKey(){
    # Read key for 0.1 seconds
    read -s -n 1 -t 0.1 key
    echo -n "$ret$d"
}

COMPOSE_FILE="./docker-compose.yml"
PROFILE="--profile default"

echo "Voulez-vous démarrer mongo ? (y/N)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  PROFILE="--profile mongo --profile default"
fi

# Set environment variables
export DAMP_DB_PORT=""
export DAMP_WEB_PORT=""
export DAMP_PMA_PORT=""
export DAMP_MONGO_PORT=""
export DAMP_HOME_DIRECTORY="./"

# Stop containers
docker-compose -f $COMPOSE_FILE down

# Scan ports and select free ports
MYSQL_PORT=$(get_free_port 3306 3316)
HTTP_PORT=$(get_free_port 8080 8099)
PMA_PORT=$(get_free_port 9090 9099)
MONGO_PORT=$(get_free_port 27017 27027)

export DAMP_DB_PORT=$MYSQL_PORT
export DAMP_WEB_PORT=$HTTP_PORT
export DAMP_PMA_PORT=$PMA_PORT
export DAMP_MONGO_PORT=$MONGO_PORT
export DAMP_HOME_DIRECTORY="./"

# Start containers
docker compose -f $COMPOSE_FILE $PROFILE up -d

main(){
    # create a window
    window "BTS SIO : DAMP" "blue" "50%"
        append "MySQL : localhost:$MYSQL_PORT"
        addsep
        append "HTTP / PHP : http://localhost:$HTTP_PORT"
        addsep
        append "PhpMyAdmin : http://localhost:$PMA_PORT"
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
        then
          addsep
          append "MongoDB : localhost:$MONGO_PORT"
        fi
    endwin
}

clear
parse_args $@
bsc_term_init
bsc_init_chars
__display

# Wait for user input
echo ""
read -p "Appuyer sur une touche pour quitter"

# Stop containers
docker compose -f $COMPOSE_FILE $PROFILE down
