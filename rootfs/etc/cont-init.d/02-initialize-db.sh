#!/usr/bin/with-contenv bash

if [ -z "$MARIADB_USER" ]; then

    if [ -f /etc/secrets/username ]; then
      export MARIADB_USER=$(cat /etc/secrets/username)
    else
      echo "No user"
      exit 1
    fi
fi

if [ -z "$MARIADB_PASSWORD" ]; then

    if [ -f /etc/secrets/password ]; then 
      export MARIADB_PASSWORD=$(cat /etc/secrets/password)  
    else 
      echo "No password"  
      exit 1
    fi
fi

/usr/bin/mysqld_safe &

mysqladmin --silent --wait=100 ping || exit 1

USER_EXISTS="$(mysql -se "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = \"$MARIADB_USER\")")"

if [ $USER_EXISTS -eq 0 ]; then

	echo "User initialization"
	echo "CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';" | mysql
	echo "GRANT ALL ON *.* TO '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

fi

if [ -z "$MARIADB_DB" ]; then

    if [ -f /etc/secrets/db ]; then 
      export MARIADB_DB=$(cat /etc/secrets/db)  
      echo "Database creation"
      echo "CREATE DATABASE IF NOT EXISTS ${MARIADB_DB};" | mysql
    else 
      echo "No db"  
    fi
else
    echo "Database creation"
    echo "CREATE DATABASE IF NOT EXISTS ${MARIADB_DB};" | mysql
fi

mysqladmin shutdown