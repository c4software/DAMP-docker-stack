@echo off

rem Set the compose file and profile
set COMPOSE_FILE="./docker-compose.yml"
set PROFILE="--profile default"

rem Ask the user if they want to start mongo
echo "Do you want to start mongo? (y/N)"
set /p response=""
if "%response%" == "y" (
  set PROFILE="--profile mongo --profile default"
)

rem Set environment variables
set MYSQL_PORT=3306
set HTTP_PORT=8080
set PMA_PORT=9090
set MONGO_PORT=27017
set DAMP_HOME_DIRECTORY=./

rem Stop containers
docker-compose -f "%COMPOSE_FILE%" "%PROFILE%" down

rem Start containers
docker compose -f "%COMPOSE_FILE%" "%PROFILE%" up -d

cls

rem Print the start message
echo DAMP is started
echo MySQL : localhost:%MYSQL_PORT%
echo HTTP / PHP : http://localhost:%HTTP_PORT%
echo PhpMyAdmin : http://localhost:%PMA_PORT%
if "%response%" == "y" (
  echo "MongoDB : localhost:%MONGO_PORT%"
)

rem Wait for user input
pause

rem Stop containers
docker compose -f "%COMPOSE_FILE%" "%PROFILE%" down
