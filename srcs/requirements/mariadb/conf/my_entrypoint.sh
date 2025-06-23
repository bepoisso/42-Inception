#!/bin/sh
set -e  # Stopper en cas d'erreur

# Lancer MySQL en arrière-plan
mysqld_safe --skip-networking &
sleep 5  # Laisser le temps à MySQL de se lancer

# Création BDD et utilisateurs
mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

# Éteindre proprement le serveur de démarrage
mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" shutdown

# Redémarrer MySQL correctement (comme processus principal)
exec mysqld_safe