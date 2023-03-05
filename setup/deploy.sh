#!/bin/bash

# Get the path to the directory containing the script
DIR=$(dirname "$(readlink -f "$0")")/..

# Path to deploy the application
APP_NAME="hover"
APP_PATH="/opt/$APP_PATH"
U_NAME="your-username"

# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install Java
sudo apt-get install -y openjdk-17-jdk openjdk-17-jre

# Configure systemd service
cat << EOF | sudo tee /etc/systemd/system/$APP_NAME.service
[Unit]
Description=Your Spring Boot Application
After=syslog.target

[Service]
User=your-username
ExecStart=/usr/bin/java -jar $DIR/build/libs/your-project.jar
SuccessExitStatus=143
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

# Deploy the application
sudo cp build/libs/your-project.jar /path/to/your-project/

# Set the owner of the application directory to the user.
sudo chown -R $U_NAME:$U_NAME "$APP_PATH"

# Set the permissions on the application directory to allow read, write, and execute access only to the owner
sudo chmod 700 "$APP_PATH"

# Set the permissions on the application files to allow read and write access only to the owner
sudo chmod 600 "$APP_PATH"/hover.jar

# Start the application.
sudo systemctl start $APP_NAME.service