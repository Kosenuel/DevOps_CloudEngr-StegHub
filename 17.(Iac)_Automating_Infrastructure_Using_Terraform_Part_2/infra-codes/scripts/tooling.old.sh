#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined variables, and pipeline failures
shopt -s inherit_errexit  # Ensure errors propagate in subshells
exec > >(tee /var/log/userdata.log) 2>&1  # Log all output

# --------------------------------------------------
# Configuration
# --------------------------------------------------
LOG_FILE="/var/log/userdata.log"
TMP_MYSQL_CNF="/tmp/.mysql.cnf"
WEB_ROOT="/var/www/html"
EFS_MOUNT="/var/www"
REPO_URL="https://github.com/kosenuel/tooling.git"
DB_HOST="terraform-adfadda.adf.eu-west-2.rds.amazonaws.com"
DB_USER="admin"
DB_PASS="your-secure-password"
APP_DB_USER="user1"
APP_DB_PASS="pass"
APP_DB_NAME="toolingdb"

# --------------------------------------------------
# Helper Functions
# --------------------------------------------------
function log {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

function retry {
    local retries=5
    local delay=10
    local attempt=1
    until "$@"; do
        log "Command failed (attempt $attempt/$retries). Retrying in $delay seconds..."
        sleep "$delay"
        if ((attempt++ >= retries)); then
            log "Command failed after $retries attempts. Exiting..."
            return 1
        fi
    done
}

function validate_command {
    if ! command -v "$1" &>/dev/null; then
        log "Required command '$1' is not installed. Exiting..."
        exit 1
    fi
}

function secure_mysql {
    # Create a secure MySQL configuration file
    cat <<EOF > "$TMP_MYSQL_CNF"
[client]
host=${DB_HOST}
user=${DB_USER}
password=${DB_PASS}
EOF
    chmod 600 "$TMP_MYSQL_CNF"
}

# --------------------------------------------------
# System Updates & Base Packages
# --------------------------------------------------
log "Updating system and installing dependencies..."
retry yum update -y
retry yum install -y git mysql make rpm-build cargo openssl-devel rust wget policycoreutils-python-utils

# --------------------------------------------------
# Install and Configure EFS Utils
# --------------------------------------------------
log "Setting up EFS..."
if ! rpm -q amazon-efs-utils; then
    log "Installing EFS utilities..."
    retry git clone https://github.com/aws/efs-utils
    pushd efs-utils >/dev/null
    retry make rpm
    retry yum install -y ./build/amazon-efs-utils*rpm
    popd >/dev/null
fi

# Create and Mount EFS (with idempotency)
mkdir -p "$EFS_MOUNT"
if ! mountpoint -q "$EFS_MOUNT"; then
    log "Mounting EFS..."
    retry mount -t efs -o tls,accesspoint=fsap-afdfad fs-adfadadads:/ "$EFS_MOUNT"
    # Add to fstab for persistence
    echo "fs-adadadad:/ $EFS_MOUNT efs _netdev,tls,accesspoint=fsap-adfadfadfa 0 0" >> /etc/fstab
fi

# --------------------------------------------------
# Install Web Stack
# --------------------------------------------------
log "Installing Apache and PHP..."
# Install Remi repo
retry yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum module reset php -y
yum module enable php:remi-8.2 -y

# Install packages
retry yum install -y httpd php php-common php-mbstring php-opcache php-intl \
    php-xml php-gd php-curl php-mysqlnd php-zip php-fpm php-json

# --------------------------------------------------
# Configure Apache & PHP
# --------------------------------------------------
log "Configuring web server..."
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php.ini
systemctl enable --now php-fpm httpd

# Firewall configuration
if systemctl is-active --quiet firewalld; then
    log "Configuring firewall..."
    firewall-cmd --permanent --add-service={http,https}
    firewall-cmd --reload
fi

# --------------------------------------------------
# Application Deployment
# --------------------------------------------------
log "Deploying application..."
mkdir -p "${WEB_ROOT}/healthz"

# Clone repo (with idempotency)
if [[ ! -d "tooling" ]]; then
    log "Cloning application repository..."
    retry git clone "$REPO_URL"
fi

# Copy files if directory is empty
if [[ -z "$(ls -A "$WEB_ROOT")" ]]; then
    log "Copying application files..."
    cp -R tooling/html/* "$WEB_ROOT/"
fi

# Set permissions
log "Setting permissions..."
chown -R apache:apache "$WEB_ROOT"

# SELinux configuration
log "Applying SELinux settings..."
setsebool -P httpd_can_network_connect=1
setsebool -P httpd_can_network_connect_db=1
setsebool -P httpd_execmem=1
setsebool -P httpd_use_nfs=1
semanage fcontext -a -t httpd_sys_rw_content_t "${WEB_ROOT}(/.*)?"
restorecon -Rv "$WEB_ROOT"

# Health check file
echo "Healthy" > "${WEB_ROOT}/healthz/index.html"
chmod 644 "${WEB_ROOT}/healthz/index.html"
mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf_backup

# --------------------------------------------------
# Database Configuration
# --------------------------------------------------
log "Configuring database..."
secure_mysql

# Wait for RDS to be available
log "Waiting for database connection..."
until mysql --defaults-extra-file="$TMP_MYSQL_CNF" -e 'SELECT 1'; do
    log "Database not yet available. Retrying in 10 seconds..."
    sleep 10
done

# Execute SQL commands
log "Setting up database and user..."
mysql --defaults-extra-file="$TMP_MYSQL_CNF" <<EOF
CREATE DATABASE IF NOT EXISTS ${APP_DB_NAME};
CREATE USER IF NOT EXISTS '${APP_DB_USER}'@'%' IDENTIFIED BY '${APP_DB_PASS}';
GRANT ALL PRIVILEGES ON ${APP_DB_NAME}.* TO '${APP_DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Import schema
log "Importing database schema..."
mysql --defaults-extra-file="$TMP_MYSQL_CNF" "$APP_DB_NAME" < tooling/tooling-db.sql

# Update application configuration
log "Updating application configuration..."
sed -i "s/\$db = mysqli_connect('127.0.0.1', 'admin', 'admin', 'tooling');/\$db = mysqli_connect('${DB_HOST}', '${APP_DB_USER}', '${APP_DB_PASS}', '${APP_DB_NAME}');/" "${WEB_ROOT}/functions.php"

# --------------------------------------------------
# Finalization
# --------------------------------------------------
log "Restarting services..."
systemctl restart httpd php-fpm

log "Provisioning completed successfully!"

