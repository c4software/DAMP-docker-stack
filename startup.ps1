# Function to get a free port
function get_free_port() {
  $start = $args[0]
  $end = $args[1]
  for ($i = $start; $i <= $end; $i++) {
    $nc_result = nc -z localhost $i
    if ($nc_result.ExitCode -ne 0) {
      return $i
    }
  }
  return 0
}

# Set the compose file and profile
$COMPOSE_FILE = "./docker-compose.yml"
$PROFILE = "--profile default"

# Ask the user if they want to start mongo
echo "Do you want to start mongo? (y/N)"
$response = read-host
if ($response.StartsWith("y")) {
  $PROFILE = "--profile mongo --profile default"
}

# Set environment variables
$DAMP_DB_PORT = ""
$DAMP_WEB_PORT = ""
$DAMP_PMA_PORT = ""
$DAMP_MONGO_PORT = ""
$DAMP_HOME_DIRECTORY = "./"

# Stop containers
docker-compose -f $COMPOSE_FILE down

# Scan ports and select free ports
$MYSQL_PORT = get_free_port(3306, 3316)
$HTTP_PORT = get_free_port(8080, 8099)
$PMA_PORT = get_free_port(9090, 9099)
$MONGO_PORT = get_free_port(27017, 27027)

# Set environment variables
$DAMP_DB_PORT = $MYSQL_PORT
$DAMP_WEB_PORT = $HTTP_PORT
$DAMP_PMA_PORT = $PMA_PORT
$DAMP_MONGO_PORT = $MONGO_PORT
$DAMP_HOME_DIRECTORY = "./"

# Start containers
docker-compose -f $COMPOSE_FILE $PROFILE up -d

# Clear the screen
clear

# Print the start message
echo "DAMP is started"
echo "MySQL : localhost:$MYSQL_PORT"
echo "HTTP / PHP : http://localhost:$HTTP_PORT"
echo "PhpMyAdmin : http://localhost:$PMA_PORT"
if ($response.StartsWith("y")) {
  echo "MongoDB : localhost:$MONGO_PORT"
}

# Wait for user input
echo ""
read-host -prompt "Press a key to quit"

# Stop containers
docker-compose -f $COMPOSE_FILE $PROFILE down
