
#!/bin/bash

# Make prometheus user adduser --no-create-home --disabled-login --shell /bin/false --gecos "Prometheus Monitoring User" prometheus

# Make directories and dummy files necessary for prometheus
 mkdir /etc/prometheus
 mkdir /var/lib/prometheus
 touch /etc/prometheus/prometheus.yml
 touch /etc/prometheus/prometheus.rules.yml

# Assign ownership of the files above to prometheus user
 chown -R prometheus:prometheus /etc/prometheus
 chown prometheus:prometheus /var/lib/prometheus

# Download prometheus and copy utilities to where they should be in the filesystem
#VERSION=2.2.1
VERSION=$(curl https://raw.githubusercontent.com/prometheus/prometheus/master/VERSION)
wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-amd64.tar.gz
tar xvzf prometheus-${VERSION}.linux-amd64.tar.gz

 cp prometheus-${VERSION}.linux-amd64/prometheus /usr/local/bin/
 cp prometheus-${VERSION}.linux-amd64/promtool /usr/local/bin/
 cp -r prometheus-${VERSION}.linux-amd64/consoles /etc/prometheus
 cp -r prometheus-${VERSION}.linux-amd64/console_libraries /etc/prometheus

# Assign the ownership of the tools above to prometheus user
 chown -R prometheus:prometheus /etc/prometheus/consoles
 chown -R prometheus:prometheus /etc/prometheus/console_libraries
 chown prometheus:prometheus /usr/local/bin/prometheus chown prometheus:prometheus /usr/local/bin/promtool

# Populate configuration files
cat ./prometheus/prometheus.yml | sudo tee /etc/prometheus/prometheus.yml
cat ./prometheus/prometheus.rules.yml | sudo tee /etc/prometheus/prometheus.rules.yml
cat ./prometheus/prometheus.service | sudo tee /etc/systemd/system/prometheus.service

# systemd
 systemctl daemon-reload
 systemctl enable prometheus
 systemctl start prometheus

# Installation cleanup
rm prometheus-${VERSION}.linux-amd64.tar.gz
rm -rf prometheus-${VERSION}.linux-amd64
