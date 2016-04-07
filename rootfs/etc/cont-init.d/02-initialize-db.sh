#!/usr/bin/with-contenv bash

if [ -z "$MARIADB_USER" ]; then
	echo "No user"
	exit 1
fi

if [ -z "$MARIADB_PASS" ]; then
	echo "No password"
	exit 1
fi

/usr/bin/mysqld_safe &

mysqladmin --silent --wait=30 ping || exit 1

USER_EXISTS="$(mysql -se "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = \"$MARIADB_USER\")")"

if [ $USER_EXISTS -eq 0 ]; then

	echo "User initialization"
	echo "CREATE USER '${MARIADB_USER}'@'localhost' IDENTIFIED BY '${MARIADB_PASS}';" | mysql
	echo "GRANT ALL ON *.* TO '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASS}' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

fi

mysqladmin shutdown