#!/bin/sh

mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

# tfile=`mktemp`
# if [ ! -f "$tfile" ]; then
#     return 1
# fi

touch tempo

cat << EOF > tempo
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$SQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$SQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${SQL_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

if [ "$SQL_DATABASE" != "" ]; then
	echo "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> tempo

	if [ "$SQL_USER" != "" ]; then
		echo "GRANT ALL ON \`$SQL_DATABASE\`.* to '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';" >> tempo
	fi
fi

/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < tempo
rm -f tempo

exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@