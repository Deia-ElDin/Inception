# Inception

A containerized WordPress setup with Docker Compose, featuring three services:
- **MariaDB** - Database server
- **WordPress** - PHP application
- **Nginx** - Web server with TLS support

## Project Structure

```
.
├── Makefile
├── secrets/
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── mariadb-server.cnf
        │   └── tools/
        │       └── entrypoint.sh
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── nginx.conf
        │   └── tools/
        │       └── entrypoint.sh
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            │   └── www.conf
            └── tools/
                ├── entrypoint.sh
                └── wp-cli.phar
```

## Features

- **Isolated Services**: Each component runs in its own container
- **Secure Communication**: HTTPS/TLS with self-signed certificates
- **Persistent Storage**: Docker volumes for database and WordPress files
- **Automated Setup**: Entrypoint scripts handle initialization of each service
- **Docker Secrets**: Sensitive credentials stored as Docker secrets

## Prerequisites

- Docker and Docker Compose
- Make

## Installation & Usage

1. Clone this repository
2. Set up the required secrets in the `/secrets` directory
3. Run `make` to build and start all containers

### Make Commands

| Command | Description |
|---------|-------------|
| `make` | Build and start all containers in detached mode |
| `make up` | Start all containers in detached mode |
| `make down` | Stop and remove all containers |
| `make build` | Build all containers |
| `make clean` | Stop containers and remove volumes |
| `make fclean` | Completely remove all containers, networks, volumes, and images |
| `make restart` | Restart all containers |
| `make log` | View logs from all containers |
| `make re` | Rebuild and restart all containers |
| `make db` | Open a shell inside the MariaDB container |

## Architecture

### MariaDB Container
- Alpine-based image
- Configured for secure remote access
- Data persisted via Docker volume

### WordPress Container
- Alpine-based image
- PHP-FPM configuration
- WordPress core automatically downloaded and configured
- WP-CLI included for administration

### Nginx Container
- Alpine-based image
- TLS/HTTPS with self-signed certificate
- Proxy configuration for PHP-FPM

## Environment Configuration

Required environment variables are set in `.env` file:

- `DOMAIN_NAME`: Domain for the WordPress site
- `DB_HOST`: Database hostname (mariadb)
- `DB_NAME`: Database name
- `DB_USER`: Database username
- `DB_ROOT_USER`: Database root username
- `MARIADB_USER`: MariaDB system user
- `MARIADB_DATABASE_DIR`: Database storage location
- `MARIADB_PLUGIN_DIR`: Plugin directory
- `MARIADB_PID_FILE`: PID file location

## Security

- Credentials are stored as Docker secrets
- Self-signed SSL certificate for HTTPS
- Services communicate over an internal Docker network

## Customization

You can modify the configuration files in the respective `conf/` directories to customize each service.

## Troubleshooting

If you encounter issues, check the container logs with `make log` or access the MariaDB container with `make db`.