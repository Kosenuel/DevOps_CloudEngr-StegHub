#!/bin/bash
set -eo pipefail
shopt -s inherit_errexit

# Configuration
LOG_FILE="/var/log/wp-install.log"
TMP_MYSQL_CNF="/tmp/.mysql.cnf"
EFS_MOUNT="/var/www"
WORDPRESS_DIR="/var/www/html"
WP_CONFIG="${WORDPRESS_DIR}/wp-config.php"

# Required environment variables
declare -A REQUIRED_VARS=(
    ["EFS_ID"]=""
    ["ACCESS_POINT"]=""
    ["RDS_ENDPOINT"]=""
    ["RDS_USER"]=""
    ["RDS_PASSWORD"]=""
    ["DB_USER"]=""
    ["DB_PASSWORD"]=""
)

# Setting the required environment variables
set_environment_variables(){
    REQUIRED_VARS["EFS_ID"]="${efs_id}"
    REQUIRED_VARS["ACCESS_POINT"]="${access_point}"
    REQUIRED_VARS["RDS_ENDPOINT"]="${rds_endpoint}"
    REQUIRED_VARS["RDS_USER"]="${rds_user}"
    REQUIRED_VARS["RDS_PASSWORD"]="${rds_password}"
    REQUIRED_VARS["DB_USER"]="${db_user}"
    REQUIRED_VARS["DB_PASSWORD"]="${db_password}"

    # Export the variables 
    for key in "${!REQUIRED_VARS[@]}"; do
        export "${key}"="${REQUIRED_VARS[$key]}"
    done
}

# Logging and error handling
trap 'error_handler $? $LINENO' ERR
exec > >(tee -a "${LOG_FILE}") 2>&1

error_handler(){
    local exit_code=$1
    local line_no=$2
    echo "Error occured at line ${line_no} with exit code ${exit_code}" >&2
    cleanup
    exit "${exit_code}"
}

cleanup(){
    rm -f "${TMP_MYSQL_CNF}" || true
    rm -rf ./efs-utils ./wordpress latest.tar.gz || true
}

validate_environment(){
    local missing=()
    for var in "${!REQUIRED_VARS[@]}"; do
        if [[ -z "${!var:-}" ]]; then 
            missing+=("${var}")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then 
        echo "Missing required environment variables: ${missing[*]}" >&2
        exit 1
    fi
}

install_efs_utils(){
    echo "Installing EFS utilities..."
    yum update -y
    yum install -y \
        git make rpm-build cargo openssl-devel rust        
    
    git clone --depth 1 https://github.com/aws/efs-utils || {
        echo "EFS utils clone failed" >&2
        return 1
    }

    pushd efs-utils >/dev/null
    make rpm || {
        echo "EFS utils build failed" >&2
        return 1
    }

    yum install -y ./build/amazon-efs-utils*rpm || {
        echo "EFS utils installation failed" >&2
        return 1
    }

    popd >/dev/null
}

mount_efs() {
    echo "Mounting EFS filesystem..."
    mkdir -p "${EFS_MOUNT}"
    local mount_options="tls,accesspoint=${ACCESS_POINT},_netdev"

    if ! mountpoint -q "${EFS_MOUNT}"; then
        mount -t efs -o "${mount_options}" "${EFS_ID}:/" "${EFS_MOUNT}" || {
            echo "EFS mount failed" >&2
            return 1
        }
    fi

    if ! grep -q "${EFS_ID}" /etc/fstab; then
        echo "${EFS_ID}:/ ${EFS_MOUNT} efs ${mount_options} 0 0" >>/etc/fstab
    fi
}

install_apache_php() {
    echo "Installing Apache and PHP..."
    # amazon-linux-extras enable php7.4 -y
    yum install -y \
        httpd mysql php php-mysqlnd php-fpm php-json php-gd php-mbstring \
        php-xml php-opcache php-intl php-curl php-zip

    systemctl enable --now httpd php-fpm
}

configure_wordpress(){
    echo "Configuring WordPress..."
    [[ -d "${WORDPRESS_DIR}" ]] || mkdir -p "${WORDPRESS_DIR}"

    if [[ ! -f "${WORDPRESS_DIR}/index.php" ]]; then
        curl -sSL https://wordpress.org/latest.tar.gz | tar xz -C /tmp
        cp -a /tmp/wordpress/* "${WORDPRESS_DIR}"
    fi

    cp "${WORDPRESS_DIR}/wp-config-sample.php" "${WP_CONFIG}"
    chown -R apache:apache "${WORDPRESS_DIR}"
    chmod 0755 "${WORDPRESS_DIR}"
}

setup_database() {
    echo "Initializing database..."
    local max_retries=10
    local retry=0

    # Create secure MySQL configuration file
    cat <<EOF >"${TMP_MYSQL_CNF}"
[client]
user="${RDS_USER}"
password="${RDS_PASSWORD}"
host="${RDS_ENDPOINT}"
EOF

    echo "Trying to connect to the database..."
    while [[ ${retry} -lt ${max_retries} ]]; do
        if mysql --defaults-extra-file="${TMP_MYSQL_CNF}" -e "SELECT 1" &>/dev/null; then
            echo "Database connection successful."
            break
        fi
        ((retry++))
        echo "Database connection failed. Retry ${retry}/${max_retries}. Waiting for $((retry * 2)) seconds before trying again..."
        sleep $((retry * 2))
    done

    if [[ ${retry} -eq ${max_retries} ]]; then
        echo "Failed to connect to the database after ${max_retries} attempts." >&2
        return 1
    fi

    echo "Running SQL commands to set up the database..."
    mysql --defaults-extra-file="${TMP_MYSQL_CNF}" <<SQL
CREATE DATABASE IF NOT EXISTS wordpressdb;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON wordpressdb.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
SQL
    echo "Database setup completed."
}


configure_wp_settings() {
    echo "Updating Wordpress configuration..."
    local salts
    salts=$(curl -sS https://api.wordpress.org/secret-key/1.1/salt/)

    sed -i "s/define( 'DB_NAME', 'database_name_here' );/define( 'DB_NAME', 'wordpressdb' );/" "${WP_CONFIG}"
    sed -i "s/define( 'DB_USER', 'username_here' );/define( 'DB_USER', '${DB_USER}');/" "${WP_CONFIG}"
    sed -i "s/define( 'DB_PASSWORD', 'password_here' );/define( 'DB_PASSWORD', '${DB_PASSWORD}' );/" "${WP_CONFIG}"
    sed -i "s/define( 'DB_HOST', 'localhost' );/define( 'DB_HOST', '${RDS_ENDPOINT}' );/" "${WP_CONFIG}"
    
    sed -i "/AUTH_KEY/d" "${WP_CONFIG}"
    echo "${salts}" >> "${WP_CONFIG}"

    # Configure FS_METHOD for proper filesystem permissions
    echo "define('FS_METHOD', 'direct');" >> "${WP_CONFIG}"
}

security_hardening() {
    echo "Applying security settings..."
    #SELinux configuration
    sudo setsebool -P httpd_can_network_connect=1
    sudo setsebool -P httpd_can_network_connect_db=1
    sudo setsebool -P httpd_execmem=1
    sudo setsebool -P httpd_use_nfs=1
    # Install the necessary dependencies to allow the smooth running of the 'SE' commands below
    dnf install -y policycoreutils-python-utils
    semanage fcontext -a -t httpd_sys_rw_content_t "${WORDPRESS_DIR}(/.*)?"
    # restorecon -Ry "${WORDPRESS_DIR}"
    restorecon -rv "${WORDPRESS_DIR}"

    #Firewall configuration
    if command -v firewall-cmd &>/dev/null; then
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        firewall-cmd --reload
    fi

    # Create health check endpoint
    mkdir -p "${WORDPRESS_DIR}/healthz"
    echo "OK and Healthy and my Mommy (Francisca is really watching you :D )" > "${WORDPRESS_DIR}/healthz/index.html"
    chown apache:apache "${WORDPRESS_DIR}/healthz/index.html"
    mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf_backup
}

main() {
    set_environment_variables
    validate_environment
    install_efs_utils
    mount_efs
    install_apache_php
    configure_wordpress
    setup_database
    configure_wp_settings
    security_hardening
    cleanup

    systemctl restart httpd
    echo "WordPress installation completed successfully!"
}

main "$@"