# Function to get a free port
function Get-FreePort($start, $end) {
    for ($i = $start; $i -le $end; $i++) {
        $socket = New-Object System.Net.Sockets.TcpClient
        try {
            $socket.Connect("localhost", $i)
            $socket.Close()
        } catch {
            return $i
        }
    }
    return 0
}

# Set the compose file and profile
$COMPOSE_FILE = ".\docker-compose.yml"
$PROFILE = "--profile default"

# Ask the user if they want to start mongo
echo "Do you want to start mongo? (y/N)"
$response = [System.Console]::ReadKey()
if ($response.toString().StartsWith("y")) {
  $PROFILE = "--profile mongo --profile default"
}

# Stop containers
$env:DAMP_DB_PORT = "3306"; $env:DAMP_WEB_PORT = "8080"; $env:DAMP_PMA_PORT = "9090"; $env:DAMP_MONGO_PORT = "27017"; $env:DAMP_HOME_DIRECTORY = "./"; 

Invoke-Expression -Command "docker compose -f $COMPOSE_FILE $PROFILE down"

echo "Démarrage en cours de DAMP"

# Scan ports and select free ports
$MYSQL_PORT = Get-FreePort 3306 3316
$HTTP_PORT = Get-FreePort 8080 8099
$PMA_PORT = Get-FreePort 9090 9099
$MONGO_PORT = Get-FreePort 27017 27027

# Set environment variables
$env:DAMP_MYSQL_PORT = $MYSQL_PORT
$env:DAMP_HTTP_PORT  = $HTTP_PORT
$env:DAMP_PMA_PORT   = $PMA_PORT
$env:DAMP_MONGO_PORT = $MONGO_PORT
$env:DAMP_HOME_DIRECTORY = "./"

$env:DAMP_DB_PORT = $MYSQL_PORT; $env:DAMP_WEB_PORT = $HTTP_PORT; $env:DAMP_PMA_PORT = $PMA_PORT; $env:DAMP_MONGO_PORT = $MONGO_PORT; $env:DAMP_HOME_DIRECTORY = "./"; 

Invoke-Expression -Command "docker compose -f $COMPOSE_FILE $PROFILE up -d"

# Clear the screen
clear

# Print the start message
echo "DAMP is started"
echo "MySQL : localhost:$MYSQL_PORT"
echo "HTTP / PHP : http://localhost:$HTTP_PORT"
echo "PhpMyAdmin : http://localhost:$PMA_PORT"
if ($response.toString().StartsWith("y")) {
  echo "MongoDB : localhost:$MONGO_PORT"
}

# Wait for user input
"Appuyer sur une touche pour quitter";
$x = [System.Console]::ReadKey()

# Stop containers
Invoke-Expression -Command "docker-compose -f $COMPOSE_FILE $PROFILE down"
