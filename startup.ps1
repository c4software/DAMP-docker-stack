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

$COMPOSE_FILE = "./docker-compose.yml"

# Stop Containers
Invoke-Expression -Command "docker compose -f $COMPOSE_FILE down"

# Scan Ports and Select Free Ports
$MYSQL_PORT = Get-FreePort 3306 3316
$HTTP_PORT  = Get-FreePort 8080 8099
$PMA_PORT   = Get-FreePort 9090 9099

# Set Environment Variables
$env:DAMP_MYSQL_PORT = $MYSQL_PORT
$env:DAMP_HTTP_PORT  = $HTTP_PORT
$env:DAMP_PMA_PORT   = $PMA_PORT

# Start Containers
#Invoke-Expression -Command "docker compose -f $COMPOSE_FILE build"
Invoke-Expression -Command "docker compose -f $COMPOSE_FILE up -d"

# Show ports and host
Write-Host "|====================================|" -ForegroundColor Green
Write-Host "|          BTS SIO : DAMP            |" -ForegroundColor Green
Write-Host "|====================================|" -ForegroundColor Green
Write-Host "| MySQL : http://localhost:$MYSQL_PORT      |" -ForegroundColor Green
Write-Host "|====================================|" -ForegroundColor Green
Write-Host "| Serveur : http://localhost:$HTTP_PORT    |" -ForegroundColor Green
Write-Host "|====================================|" -ForegroundColor Green
Write-Host "| PhyMyAdmin : http://localhost:$PMA_PORT |" -ForegroundColor Green
Write-Host "|====================================|" -ForegroundColor Green

# Wait for user input
"Appuyer sur une touche pour quitter";
$x = [System.Console]::ReadKey()

# Stop Containers
Invoke-Expression -Command "docker compose -f $COMPOSE_FILE down"
