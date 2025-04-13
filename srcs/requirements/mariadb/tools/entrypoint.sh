#!/bin/sh

openrc # Initializes the OpenRC service manager that was installed in the Dockerfile.
mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld
# Creates the directory for MySQL's runtime files and sets ownership to the mysql user.

# initialize the database the first time the container runs, and then start MariaDB with the right configuration.
if [ ! -d "${MARIADB_DATABASE_DIR}/mysql" ]; then
    # This conditional block checks if the database has been initialized:
        # It looks for the "mysql" system database directory within the main database directory.
        # If it doesn't exist, this is the first time the container is starting.

    rc-service mariadb setup
        # runs the initial database setup.
    rc-service mariadb start
        # temporarily starts the MariaDB service.
        
    DB_PASSWORD=$(cat /run/secrets/DB_PASSWORD)
    DB_ROOT_PASSWORD=$(cat /run/secrets/DB_ROOT_PASSWORD)
    # the /run directory itself, as it already exists in the Alpine Linux base image.
    
    # mysql -u $DB_ROOT_USER -e " means that you're running the MySQL command-line client:
    #   1) -u $DB_ROOT_USER specifies which user to connect as
    #   2) -e "..." means "execute the following SQL commands
    mysql -u $DB_ROOT_USER -e "
    CREATE DATABASE IF NOT EXISTS $DB_NAME;
    CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
    GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
    ALTER USER '$DB_ROOT_USER'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';"

    # FLUSH PRIVILEGES; - Makes the privilege changes take effect immediately without restarting the database.

    mysqladmin -u root shutdown
    # shuts down the temporary MariaDB
fi

## start mariadb 
/usr/bin/mariadbd --user=$MARIADB_USER \
    --datadir=$MARIADB_DATABASE_DIR \
    --plugin-dir=$MARIADB_PLUGIN_DIR \
    --pid-file=$MARIADB_PID_FILE

# /usr/bin/mariadbd - This is the actual MariaDB server daemon executable
# --user=$MARIADB_USER - Specifies which system user the database process should run as for security reasons
# --datadir=$MARIADB_DATABASE_DIR - Tells MariaDB where to store all database files (tables, indexes, etc.)
# --plugin-dir=$MARIADB_PLUGIN_DIR - Specifies the directory where MariaDB plugins are located
# --pid-file=$MARIADB_PID_FILE - Indicates where to save the process ID file, 
#   which is used to track the running MariaDB process


# mysql -u root -proot
# SHOW DATABASES;
# USE mydatabase
# SHOW TABLES;
# SELECT * FROM wp_comments;