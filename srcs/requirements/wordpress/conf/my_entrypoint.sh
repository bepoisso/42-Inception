#!/bin/bash

echo "Waiting for MariaDB to start (30s)..."
sleep 30

PHP_POOL_CONF="/etc/php/7.4/fpm/pool.d/www.conf"
PHP_FPM_CONF="/etc/php/7.4/fpm/php-fpm.conf"

# Ensure the pool config includes the correct listen directive
if grep -q "^listen\s*=" "$PHP_POOL_CONF"; then
    sed -i 's|^listen\s*=.*|listen = wordpress:9000|' "$PHP_POOL_CONF"
else
    echo "listen = wordpress:9000" >> "$PHP_POOL_CONF"
fi

# Append clear_env if it is not present
if ! grep -q "^clear_env\s*=" "$PHP_POOL_CONF"; then
    echo "clear_env = no" >> "$PHP_POOL_CONF"
fi

# Ensure php-fpm.conf includes pool.d/*.conf
if ! grep -q "include\s*=\s*/etc/php/7.4/fpm/pool.d/\*.conf" "$PHP_FPM_CONF"; then
    echo "include=/etc/php/7.4/fpm/pool.d/*.conf" >> "$PHP_FPM_CONF"
fi

# Dossier WordPress
WORDPRESS_PATH="/var/www/wordpress"

# Télécharger WordPress s'il n'existe pas déjà
if [ ! -f "$WORDPRESS_PATH/wp-config-sample.php" ]; then
    echo ">> Téléchargement de WordPress..."
    wp core download --path="$WORDPRESS_PATH" --allow-root
fi

# Créer wp-config.php
if [ ! -f "$WORDPRESS_PATH/wp-config.php" ]; then
    echo ">> Génération du fichier wp-config.php..."
    wp config create \
        --allow-root \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306" \
        --path="$WORDPRESS_PATH"
fi

# Installation de WordPress si pas encore installée
if ! wp core is-installed --path="$WORDPRESS_PATH" --allow-root; then
    echo ">> Installation de WordPress..."
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception by $LOGIN" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PWD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root \
        --path="$WORDPRESS_PATH"
fi

# Lancement de PHP-FPM
mkdir -p /run/php
exec /usr/sbin/php-fpm7.4 -F
