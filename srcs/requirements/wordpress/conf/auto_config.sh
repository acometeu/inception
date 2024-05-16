#!/bin/sh

sleep 10

#wp core download --allow-root
#wp config create --allow-root
#wp config create	--allow-root \
#					--dbname=$SQL_DATABASE \
#					--dbuser=$SQL_USER \
#					--dbpass=$SQL_PASSWORD \
#					--dbhost=mariadb:3306 --path='/var/www/wordpress'

if [ ! -e "/var/www/html/wp-config.php" ]; then

	cd /var/www/html
	wp core download --allow-root

	wp config create --dbname=${MARIADB_DB} --dbuser=${MARIADB_USER} \
				--dbpass=${MARIADB_PWD} --dbhost=mariadb

	wp core install --allow-root --url=${WORDPRESS_HOST} \
				--title=${WORDPRESS_TITLE} --admin_user=${WORDPRESS_ADMIN_USER} \
				--admin_password=${WORDPRESS_ADMIN_PWD} \
				--admin_email=${WORDPRESS_ADMIN_EMAIL} \
				--skip-email

	wp user create --allow-root ${WORDPRESS_USER} ${WORDPRESS_EMAIL} \
				--role=author --user_pass=${WORDPRESS_PWD}

	wp plugin install redis-cache --activate

	wp config set WP_REDIS_HOST 'redis'

	wp redis enable
fi

exec php-fpm81 -F
