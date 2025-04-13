#!/bin/sh

mkdir -p /var/www/html/wordpress
cd /var/www/html/wordpress

if [ ! -f "wp-config.php" ] && [ ! -f "wp-config-sample.php" ]; then
    echo "Downloading WordPress..."
    php -d memory_limit=512M /usr/local/bin/wp --allow-root core download
    mv wp-config-sample.php wp-config.php
fi
# Checks if WordPress is already installed by looking for configuration files
# If not found, downloads WordPress core using WP-CLI
# Sets a higher memory limit temporarily for the download

chmod 777 -R /var/www/html/wordpress

WP_USER=$(grep "^WP_USER=" /run/secrets/CREDENTIALS | cut -d "=" -f 2)
WP_PASS=$(grep "^WP_PASS=" /run/secrets/CREDENTIALS | cut -d "=" -f 2)
WP_EMAIL=$(grep "^WP_EMAIL=" /run/secrets/CREDENTIALS | cut -d "=" -f 2)

WP_USER2=$(grep "^WP_USER2=" /run/secrets/CREDENTIALS | cut -d "=" -f 2)
WP_PASS2=$(grep "^WP_PASS2=" /run/secrets/CREDENTIALS | cut -d "=" -f 2)
WP_EMAIL2=$(grep "^WP_EMAIL2=" /run/secrets/CREDENTIALS | cut -d "=" -f 2)

DB_PASSWORD=$(cat /run/secrets/DB_PASSWORD)

sed -i "s/'database_name_here'/'$DB_NAME'/g" wp-config.php
sed -i "s/'username_here'/'$DB_USER'/g" wp-config.php
sed -i "s/'password_here'/'$DB_PASSWORD'/g" wp-config.php
sed -i "s/'localhost'/'$DB_HOST'/g" wp-config.php
sed -i "/<?php/a \\if ( isset( \$_SERVER['HTTP_HOST'] ) ) { \\n    \$site_url = 'https://' . \$_SERVER['HTTP_HOST']; \\n    define( 'WP_HOME', \$site_url ); \\n    define( 'WP_SITEURL', \$site_url ); \\n}" wp-config.php
# sed commands are modifying the WordPress configuration file (wp-config.php) 
# Replaces 'username_here' with $DB_USER
# if ( isset( $_SERVER['HTTP_HOST'] ) ) {
#     $site_url = 'https://' . $_SERVER['HTTP_HOST'];
#     define( 'WP_HOME', $site_url );
#     define( 'WP_SITEURL', $site_url );
# }
# This code:

# Checks if the HTTP host is set
# Creates a site URL using HTTPS and the current hostname
# Sets WordPress constants WP_HOME and WP_SITEURL accordingly

# This is crucial for your setup because:

# It ensures WordPress knows its own URL
# It forces WordPress to use HTTPS
# It makes WordPress work correctly behind your Nginx proxy
# It allows the site to be accessed with the correct domain name

if ! wp --allow-root --path=/var/www/html/wordpress core is-installed; then
    SITE_URL="https://${DOMAIN_NAME:-localhost}"
    # This uses WP-CLI to check if WordPress is already installed

    wp --allow-root --path=/var/www/html/wordpress core install \
        --url="${SITE_URL}" --title='WordPress' \
        --skip-email --admin_email="$WP_EMAIL" \
        --admin_user="$WP_USER" \
        --admin_password="$WP_PASS"
fi
# This setup ensures WordPress is installed automatically only if needed, using credentials from your Docker secrets

if ! wp --allow-root --path=/var/www/html/wordpress user list --field=user_login | grep -q "^$WP_USER2$"; then
    wp --allow-root --path=/var/www/html/wordpress user create \
        $WP_USER2 $WP_EMAIL2 --role=subscriber \
        --user_pass="$WP_PASS2"
fi

if [ -f /var/www/html/wordpress/wp-config.php ]; then
	php-fpm83 --nodaemonize
fi
# This is a critical section that actually starts the PHP processor for your WordPress site: