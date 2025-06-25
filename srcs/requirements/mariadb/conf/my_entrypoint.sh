#!/bin/sh
set -e

echo ">> Initialisation de la base MariaDB..."

# Création du socket dir et permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Si la base n’a jamais été initialisée, on l’initialise
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo ">> Initialisation de la base de données..."
  mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

  echo ">> Démarrage temporaire de MariaDB..."
  mysqld --skip-networking --socket=/run/mysqld/mysqld.sock &

  echo ">> Attente de la disponibilité du serveur MariaDB..."
  for i in $(seq 1 30); do
    if mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; then
      break
    fi
    echo "⏳ En attente... ($i)"
    sleep 1
  done

  echo ">> Configuration initiale de la base..."
  mysql --socket=/run/mysqld/mysqld.sock -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
EOSQL

  echo ">> Extinction de la base temporaire..."
  mysqladmin --socket=/run/mysqld/mysqld.sock -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
else
  echo ">> Base MariaDB déjà initialisée, skip de l'init."
fi

echo ">> Lancement final de MariaDB..."
exec mysqld
