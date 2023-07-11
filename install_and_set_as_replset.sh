#!/bin/bash

# Function to install necessary packages
install_packages() {
  # Update the package list
  sudo apt-get update

  # Install gnupg and curl
  sudo apt-get install -y gnupg curl
}

# Function to install MongoDB 6.0 LTS version
install_mongodb() {
  # Import the public key used by the package management system
  curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor

  # Update the package list and add the MongoDB repository configuration
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

  # Update the package list
  sudo apt-get update

  # Install MongoDB packages
  sudo apt-get install -y mongodb-org
}

# Function to modify MongoDB configuration
modify_mongodb_config() {
  # Get the path of the MongoDB configuration file
  config_file="/etc/mongod.conf"

  # Modify the configuration file
  sudo sed -i "s/#replication:/replication:\n  replSetName: myReplSet\n/" $config_file

  # Add the port, data directory, and log file path
  sudo sed -i "s/#  port: 27017/  port: $1/" $config_file
  sudo sed -i "s#  dbPath: /var/lib/mongodb#  dbPath: $2#" $config_file
  sudo sed -i "s#  logPath: /var/log/mongodb/mongod.log#  logPath: $3#" $config_file
}

# Function to start MongoDB instance
start_mongodb() {
  # Start MongoDB service
  sudo systemctl start mongod
}

# Install necessary packages
install_packages

# Install MongoDB 6.0 LTS
install_mongodb

# Modify MongoDB configuration
modify_mongodb_config "$1" "$2" "$3"

# Start MongoDB instance
start_mongodb
#How to use this script ./install_mongodb.sh 27017 /data/db /var/log/mongodb.log
