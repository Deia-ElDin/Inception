# ⚠️ Security Notice - Project Secrets

## Important Disclaimer

This directory contains sensitive information such as passwords, API keys, and other credentials that are **normally NEVER committed to version control** in real-world projects.

### Why Are These Here?

These secrets are included in this repository **ONLY** because this is a learning project (42 School's Inception project). This allows for:
- Easier project evaluation
- Learning purposes
- Demonstration of configuration

### 🔐 Current Implementation

In this project, we're using Docker Secrets for secure credential management:

1. **Secret Files**:
   - `db_password.txt`: Database user password
   - `db_root_password.txt`: Database root password
   - `credentials.txt`: WordPress credentials

2. **Docker Compose Integration**:
   ```yaml
   secrets:
     DB_PASSWORD:
       file: ../secrets/db_password.txt
     DB_ROOT_PASSWORD:
       file: ../secrets/db_root_password.txt
     CREDENTIALS:
       file: ../secrets/credentials.txt
   ```

3. **Service Access**:
   - MariaDB accesses: `DB_PASSWORD`, `DB_ROOT_PASSWORD`
   - WordPress accesses: `DB_PASSWORD`, `CREDENTIALS`

4. **Secret Mounting**:
   - Secrets are mounted at `/run/secrets/<secret_name>` in containers
   - Services read secrets from this location instead of environment variables
   - This provides better security than environment variables as secrets are:
     * File-based (not exposed in process environment)
     * Access-controlled
     * Automatically removed when container stops

### ❗ Real-World Best Practices

In production environments, you should:

1. **NEVER** commit secrets to version control
2. Use environment variables or secure secret management systems
3. Implement proper key rotation and management
4. Use tools like `.gitignore` to prevent accidental commits of sensitive data

### 🛡 Recommended Security Measures

For real projects, consider using:
- Environment variables
- Secret management services (HashiCorp Vault, AWS Secrets Manager)
- Docker secrets with external secret stores
- Configuration management tools

---

### 📖 How to Use These Secrets

1. **Reading Secrets in Containers**:
   ```bash
   # Example: Reading database password
   DB_PASSWORD=$(cat /run/secrets/DB_PASSWORD)
   
   # Example: Reading credentials
   WP_USER=$(grep "^WP_USER=" /run/secrets/CREDENTIALS | cut -d "=" -f 2)
   ```

2. **Why Not in .env?**
   - Environment variables can be exposed through process lists
   - They might be logged accidentally
   - Docker secrets provide better isolation and security
   - Secrets are removed when container stops

**Note**: This documentation exists to emphasize that the presence of secrets in this repository is strictly for educational purposes and should not be replicated in production environments.