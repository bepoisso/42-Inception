#!/bin/bash

echo "Waiting for mariaDB start 30"
sleep 30

wp config create	--allow-root            \
					--dbname=$SQL_DATABASE  \
					--dbuser=$SQL_USER      \
					--dbpass=$SQL_PASSWORD  \
					--dbhost=mariadb:3306 --path='/var/www/wordpress'

wp core install     --url="$DOMAIN_NAME"				\
		            --title="Inception by $LOGIN"		\
		            --admin_user="$WP_ADMIN_USER"		\
		            --admin_password="$WP_ADMIN_PWD"	\
		            --admin_email="$WP_ADMIN_EMAIL"		\
		            --skip-email						\
		            --allow-root

mkdir -p /run/php
exec /usr/sbin/php-fpm7.4 -F