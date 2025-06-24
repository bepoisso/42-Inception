#!/bin/sh
set -e

echo ">> Initialisation de la base MariaDB..."

# Création du socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Vérifie si la base est déjà initialisée
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo ">> Démarrage temporaire de MariaDB..."
  mysqld_safe --skip-networking &
  sleep 5

  echo ">> Configuration initiale de la base..."
  mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

  echo ">> Extinction de la base temporaire..."
  mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
else
  echo ">> Base MariaDB déjà initialisée, skip de l'init."
fi

echo ">> Lancement final de MariaDB..."
exec mysqld
