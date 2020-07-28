#! /bin/bash

# Wait that mysql was up
until mysql
do
	echo "NO_UP"
done

# Init DB
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password && \
echo "CREATE USER 'user'@'%' IDENTIFIED BY 'password';" | mysql -u root --skip-password && \
echo "GRANT ALL ON *.* TO 'user'@'%' WITH GRANT OPTION;" | mysql -u root --skip-password && \
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

mysql wordpress -u root --skip-password < /tmp/wordpress.sql
# mysql wordpress -u root -skip--password  < /tmp/wordpress.sql