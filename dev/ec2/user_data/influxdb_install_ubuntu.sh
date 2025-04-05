#!/bin/bash
# Install InfluxDB on Ubuntu 24.04

# Add InfluxData key
wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -

# Add repository
echo "deb https://repos.influxdata.com/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

# Update & install InfluxDB
sudo apt-get update
sudo apt-get install -y influxdb

# Enable & start service
sudo systemctl enable influxdb
sudo systemctl start influxdb

# Install InfluxDB client
sudo apt install influxdb-client