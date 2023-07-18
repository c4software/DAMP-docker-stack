@echo off
chcp 437 >nul
Setlocal EnableDelayedExpansion

rem Set the compose file and profile
set COMPOSE_FILE="./docker-compose.yml"
set PROFILE=--profile default

echo -----------------------------------
echo Voulez-vous demarrer MongoDB? (o/N)
echo -----------------------------------
set /p mongo=""
if "%mongo%" == "o" (
  set PROFILE=--profile mongo !PROFILE!
)

echo -----------------------------------
echo Voulez-vous demarrer MailHog? (o/N)
echo -----------------------------------
set /p mailhog=""
if "%mailhog%" == "o" (
  set PROFILE=--profile mailhog %PROFILE%
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
docker compose -f %COMPOSE_FILE% %PROFILE% down

rem Start containers
docker compose -f %COMPOSE_FILE% %PROFILE% up -d

cls

echo --------------------------------
echo  DAMP - Docker Apache MySQL PHP 
echo --------------------------------
echo.
echo.
echo - MySQL : localhost:%DAMP_DB_PORT%
echo - HTTP / PHP : http://localhost:%DAMP_WEB_PORT%
echo - PhpMyAdmin : http://localhost:%DAMP_PMA_PORT%
if "%mongo%" == "o" (
  echo - MongoDB : localhost:%DAMP_MONGO_PORT%
)
if "%mailhog%" == "o" (
  echo - MailHog : http://localhost:%DAMP_MAIL_PORT% / smtp://localhost:%DAMP_MAIL_PORT_WEB%
)
echo.
echo.
echo ----------------------------------------
echo  Appuyez sur une touche pour quitter...
echo ----------------------------------------
pause >nul

docker compose -f %COMPOSE_FILE% %PROFILE% down
