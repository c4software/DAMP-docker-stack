# DAMP - Docker Apache MySQL PHP

Ce repository contient les sources du projet DAMP, un environnement de développement web basé sur Docker.

Ce projet peut être utilisé tel quel :

- en utilisant le script `startup.sh`.
- ou via l'interface graphique [disponible ici](https://github.com/c4software/DAMP)

## Installation

Pour fonctionner, vous devez :

- Avoir docker sur votre machine (voir [ici](https://docs.docker.com/install/)).
- Avoir Bash ou DAMP GUI (interface graphique).

## Versions

Le projet utilise actuellement les versions suivantes :

- PHP 8.2 (avec pdo, zip, libpng)
- MariaDB 10.9
- PhpMyAdmin (dernière version)
- MongoDB (dernière version)

Vous pouvez modifier les versions dans le fichier `docker-compose.yml`, et dans le dossier `dockerfiles` pour PHP qui utilise une version personnalisée.

## Utilisation

### Via le script `startup.sh`

Pour lancer le projet, il suffit de lancer le script `startup.sh` :

```bash
./startup.sh
```

![Démo DAMP](./demo.jpg)

### Via l'interface graphique

Il suffit de configurer le fichier `configuration.yaml` pour faire pointer l'interface la clé `home:` dans le dossier qui contient le `docker-compose.yml`.

Exemple :

```yaml
home: C:\Users\VOTRE_UTILISATEUR\docker-damp
services:
  WEB:
    id: WEB
    name: Web
    port: 8080
    minPort: 8080
    maxPort: 9099
    state: STOPPED
    profile: web
  DB:
    id: DB
    name: Database
    port: 3306
    minPort: 3306
    maxPort: 3316
    state: STOPPED
    profile: db
  PMA:
    id: PMA
    name: PhpMyAdmin
    port: 9090
    minPort: 9090
    maxPort: 9099
    state: STOPPED
    profile: pma
  MONGO:
    id: MONGO
    name: MongoDB
    port: 27017
    minPort: 27017
    maxPort: 27050
    state: STOPPED
    profile: mongo
```