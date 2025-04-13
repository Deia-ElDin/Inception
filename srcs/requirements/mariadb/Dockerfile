FROM alpine:3.20
# 3.20 is the most stable version so far

RUN apk update
# Alpine Package Keeper (apk)
# installing the most up-to-date versions of the packages available for your Alpine version.

RUN apk add mariadb mariadb-client openrc
# mariadb: The database server itself
# mariadb-client: Command-line tools for interacting with MariaDB
# openrc: Alpine's init system, needed to manage services

RUN mkdir -p /run/openrc && touch /run/openrc/softlevel
# creating the necessary directory structure and files for OpenRC
# mkdir -p /run/openrc: Creates the /run/openrc directory
# (parents) -p flag ensures all parent directories are created as needed, and doesn't error if the directory already exists
# Why this is necessary:
#   1- OpenRC typically expects to run on a full system and looks for certain files in specific locations
#   2- Creating the /run/openrc/softlevel file is a way to trick OpenRC into thinking it's running on a normal system

COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
# (mariadb-server.cnf) contains MariaDB server configuration settings (bind-address=0.0.0.0)
# The file is placed in /etc/my.cnf.d/ because this is a standard location where MariaDB looks for configuration files.

COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
# The +x permission (executable) is necessary because the file is used as the container's entrypoint script. Without this permission, 
# when Docker tries to execute the script upon container startup, it would fail with a "permission denied" error.

ENTRYPOINT [ "/entrypoint.sh" ]
