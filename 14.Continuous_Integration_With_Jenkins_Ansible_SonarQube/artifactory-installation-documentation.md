# JFrog Artifactory Installation Guide
## Ubuntu Server Implementation

### 1. Introduction

#### 1.1 Overview
This document provides detailed instructions for installing JFrog Artifactory on Ubuntu Server. Artifactory is a universal DevOps solution providing end-to-end automation and management of binaries and artifacts through the application delivery process.

#### 1.2 Prerequisites
- Ubuntu Server (20.04 LTS or newer)
- Minimum 4GB RAM
- Minimum 50GB storage space
- Root or sudo access
- Internet connectivity
- OpenJDK 17 or higher

### 2. System Preparation

#### 2.1 Update System Packages
```bash
# Update package index
sudo apt update

# Upgrade existing packages
sudo apt upgrade -y
```

#### 2.2 Install Required Dependencies
```bash
# Install basic required packages
sudo apt install -y wget curl software-properties-common apt-transport-https
```

#### 2.3 Install Java
```bash
# Install OpenJDK 17
sudo apt install -y openjdk-17-jdk

# Verify Java installation
java -version
```

### 3. Artifactory Installation

#### 3.1 Add JFrog Repository
```bash
# Download and add the JFrog GPG key
curl -fsSL https://releases.jfrog.io/artifactory/api/gpg/key/public | sudo tee /etc/apt/trusted.gpg.d/jfrog.asc

# Add JFrog repository to sources list
echo "deb https://releases.jfrog.io/artifactory/artifactory-debs xenial main" | sudo tee /etc/apt/sources.list.d/jfrog.list
```

#### 3.2 Install Artifactory
```bash
# Update package index with new repository
sudo apt update

# Install Artifactory OSS version
sudo apt install -y jfrog-artifactory-oss
```

### 4. Post-Installation Configuration

#### 4.1 Start and Enable Service
```bash
# Start Artifactory service
sudo systemctl start artifactory

# Enable Artifactory to start on boot
sudo systemctl enable artifactory

# Check service status
sudo systemctl status artifactory
```

#### 4.2 Configure Firewall (if enabled)
```bash
# Allow Artifactory default port
sudo ufw allow 8081/tcp
sudo ufw reload
```

### 5. Initial Access

#### 5.1 Access Information
- URL: `http://your-server-ip:8081`
- Default Credentials:
  - Username: admin
  - Password: password

#### 5.2 Important First Steps
1. Change default admin password
2. Configure repository settings
3. Set up users and permissions
4. Configure backup settings

### 6. System Verification

#### 6.1 Log Monitoring
```bash
# Monitor Artifactory logs
tail -f /opt/jfrog/artifactory/var/log/artifactory-service.log
```

#### 6.2 Health Check
```bash
# Check system status
curl -i http://localhost:8081/artifactory/api/system/ping
```

### 7. Troubleshooting Guide

#### 7.1 Common Issues

##### Repository Key Issues
```plaintext
Problem: GPG key retrieval fails
Solution: 
1. Remove existing key:
   sudo rm /etc/apt/trusted.gpg.d/jfrog.asc
2. Try alternative key download method:
   curl -fsSL https://releases.jfrog.io/artifactory/api/gpg/key/public | sudo tee /etc/apt/trusted.gpg.d/jfrog.asc
```

##### Service Start Issues
```plaintext
Problem: Service fails to start
Solutions:
1. Check Java installation:
   java -version
2. Verify system resources:
   free -m
   df -h
3. Check logs:
   sudo journalctl -u artifactory
```

### 8. Maintenance

#### 8.1 Backup Configuration
```bash
# Backup locations
/opt/jfrog/artifactory/var/etc/            # Configuration files
/opt/jfrog/artifactory/var/data/           # Repository data
/opt/jfrog/artifactory/var/etc/security/   # Security configuration
```

#### 8.2 System Updates
```bash
# Update Artifactory
sudo apt update
sudo apt install jfrog-artifactory-oss
```

### 9. Security Recommendations

1. Configure SSL/TLS
2. Use reverse proxy (Nginx/Apache)
3. Implement regular backup strategy
4. Configure email notifications
5. Set up audit logging

### 10. Resource Requirements

#### Minimum Requirements
- RAM: 4GB
- CPU: 2 cores
- Disk Space: 50GB

#### Recommended Requirements
- RAM: 8GB
- CPU: 4 cores
- Disk Space: 200GB+
- Solid State Drive (SSD)

