#!/bin/bash
# Create environment file with correct Eureka URL
cat > /opt/service1/service1.env << 'ENVEOF'
EUREKA_URL=${eureka_url}
SERVER_PORT=9001
SPRING_APP_NAME=service1
DB_URL=${db_url}
DB_USER=${db_username}
DB_PASSWORD=${db_password}
ENVEOF

chown service1:service1 /opt/service1/service1.env 2>/dev/null || true
chmod 600 /opt/service1/service1.env 2>/dev/null || true

# Create systemd override
mkdir -p /etc/systemd/system/service1.service.d
cat > /etc/systemd/system/service1.service.d/override.conf << 'SYSTEMDEOF'
[Service]
EnvironmentFile=/opt/service1/service1.env
SYSTEMDEOF

sed -i 's|PLACEHOLDER|${var.eureka_ip}|g' /opt/service1/service1.env
systemctl daemon-reload
systemctl restart service1

echo "Service1 configured with Eureka URL: ${eureka_url}"