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
  sudo sed -i 's/#replication:/replication:\n  replSetName: myReplSet/' $config_file
}

# Install necessary packages
install_packages

# Install MongoDB 6.0 LTS
install_mongodb

# Modify MongoDB configuration
modify_mongodb_config
