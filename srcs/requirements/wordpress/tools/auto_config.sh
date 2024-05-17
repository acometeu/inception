#!/bin/sh

sleep 10

if [ ! -f "/var/www/html/wp-config.php" ]; then

	wp config create	--allow-root \
						-dbname=${SQL_DATABASE} \
						-dbuser=${SQL_USER} \
						-dbpass=${SQL_PASSWORD} \
						-dbhost=mariadb:3306 --path='/var/www/html'

	wp core install	--allow-root \
					--url=${DOMAIN_NAME} \
					--title=${WP_TITLE} \
					--admin_user=${WP_ADMIN} \
					--admin_password=${WP_ADMIN_PASSWORD} \
					--admin_email=${WP_ADMIN_EMAIL} \
					--skip-email

	wp user create	--allow-root \
					${WP_USER} ${WP_USER_EMAIL} \
					--user_pass=${WP_USER_PASSWORD} \
					--role=author

	wp plugin install redis-cache --activate
	wp config set 'WP_REDIS_HOST' 'localhost'
	wp redis enable
	
fi

php-fpm8 -F
