#!/bin/sh
set -e  # Stopper en cas d'erreur

# Lancer MySQL en arrière-plan
mysqld_safe --skip-networking &
sleep 5  # Laisser le temps à MySQL de se lancer

# Création BDD et utilisateurs
mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

# Éteindre proprement le serveur de démarrage
mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Redémarrer MySQL correctement (comme processus principal)
exec mysqld_safe