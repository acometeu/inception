#!/bin/sh

sleep 10

if [ ! -f "/var/www/html/wp-config.php" ]; then

	cd /var/www/html
	wp core download --allow-root

	wp config create	--dbname=${SQL_DATABASE} \
						--dbuser=${SQL_USER} \
						--dbpass=${SQL_PASSWORD} \
						--dbhost=mariadb

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
	
fi

exec php-fpm81 -F
