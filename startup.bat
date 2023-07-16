@echo off

rem Set the compose file and profile
set COMPOSE_FILE="./docker-compose.yml"
set PROFILE="--profile default"

rem Ask the user if they want to start mongo
echo "Do you want to start mongo? (y/N)"
set /p mongo=""
if "%mongo%" == "y" (
  set PROFILE=!--profile mongo %PROFILE%!

rem Ask the user if they want to start MailHog
echo "Do you want to start MailHog? (y/N)"
set /p mailhog=""
if "%mailhog%" == "y" (
  set PROFILE=!--profile mailhog %PROFILE%!
)

rem Set environment variables
set DAMP_DB_PORT=3306
set DAMP_WEB_PORT=8080
set DAMP_PMA_PORT=9090
set DAMP_MONGO_PORT=27017
set DAMP_MAIL_PORT=1025
set DAMP_MAIL_PORT_WEB=8025
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
if "%mongo%" == "y" (
  echo "MongoDB : localhost:%MONGO_PORT%"
)
if "%mailhog%" == "y" (
  echo "MailHog : http://localhost:%MAIL_PORT_WEB% / smtp://localhost:%MAIL_PORT%"
)

rem Wait for user input
pause

rem Stop containers
docker compose -f "%COMPOSE_FILE%" "%PROFILE%" down
