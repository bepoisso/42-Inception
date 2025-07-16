#!/bin/bash

if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    echo "error: Missing environment variables"
    exit 1
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database init"
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db
fi

echo "Temporary DB in safe mode for configuration..."
mysqld_safe --datadir=/var/lib/mysql --skip-networking &
pid="$!"

until mysqladmin ping --silent; do
    sleep 1
    echo "try to ping mysqladmin..."
done

echo "Ping success"
echo "MariaDB is running"

echo "User and DB config:"

mysql -h localhost -uroot <<EOSQL
    -- Set root password
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'
        PASSWORD EXPIRE NEVER
        ACCOUNT UNLOCK;

    CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

    -- Recreate users to ensure correct password
    DROP USER IF EXISTS '${MYSQL_USER}'@'%';
    DROP USER IF EXISTS '${MYSQL_USER}'@'localhost';
    DROP USER IF EXISTS '${MYSQL_USER}'@'wordpress';
    DROP USER IF EXISTS '${MYSQL_USER}'@'wordpress.srcs_inception';

    CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
    CREATE USER '${MYSQL_USER}'@'wordpress' IDENTIFIED BY '${MYSQL_PASSWORD}';
    CREATE USER '${MYSQL_USER}'@'wordpress.srcs_inception' IDENTIFIED BY '${MYSQL_PASSWORD}';

    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'localhost';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'wordpress';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'wordpress.srcs_inception';

    DELETE FROM mysql.user WHERE User='';
    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

    FLUSH PRIVILEGES;
EOSQL

cat > /tmp/mysqladmin.cnf << EOF
[client]
user=root
password=${MYSQL_ROOT_PASSWORD}
EOF

chmod 600 /tmp/mysqladmin.cnf

echo "Temporary stop MariaDB"
mysqladmin --defaults-file=/tmp/mysqladmin.cnf shutdown

rm /tmp/mysqladmin.cnf

echo "MariaDB final start"
exec mysqld --user=mysql --console
