#!/bin/bash

# Jenkins Setup Script for EC2 Ubuntu Instance
# This script installs Docker, Docker Compose, and sets up Jenkins

set -e

echo "=========================================="
echo "Jenkins Setup Script for EC2 Ubuntu"
echo "=========================================="

# Update system packages
echo "Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install required packages
echo "Installing required packages..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    unzip \
    wget

# Install Docker
echo "Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Add Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    # Start and enable Docker
    sudo systemctl start docker
    sudo systemctl enable docker
    
    echo "Docker installed successfully!"
else
    echo "Docker is already installed."
fi

# Install Docker Compose
echo "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    # Get latest version
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    
    # Download and install
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    echo "Docker Compose installed successfully!"
else
    echo "Docker Compose is already installed."
fi

# Create Jenkins directory
echo "Creating Jenkins directory..."
mkdir -p ~/jenkins-setup
cd ~/jenkins-setup

# Clone or download Jenkins configuration
echo "Setting up Jenkins configuration..."
if [ -d "Jcasc_config" ]; then
    echo "Jenkins configuration directory already exists. Updating..."
    cd Jcasc_config
    git pull origin main
else
    echo "Cloning Jenkins configuration..."
    git clone https://github.com/rajops-lab/Jcasc_config.git
    cd Jcasc_config
fi

# Create environment file from example
if [ ! -f ".env" ]; then
    echo "Creating environment file..."
    cp env.example .env
    echo "Please edit .env file with your actual values before starting Jenkins!"
    echo "Run: nano .env"
else
    echo "Environment file already exists."
fi

# Set proper permissions
echo "Setting permissions..."
sudo chown -R $USER:$USER ~/jenkins-setup
chmod +x setup-jenkins.sh

echo "=========================================="
echo "Setup completed successfully!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Edit the .env file with your actual values:"
echo "   nano .env"
echo ""
echo "2. Start Jenkins:"
echo "   docker-compose up -d"
echo ""
echo "3. Access Jenkins at: http://your-ec2-public-ip:8080"
echo ""
echo "4. Check logs if needed:"
echo "   docker-compose logs -f jenkins"
echo ""
echo "5. Stop Jenkins:"
echo "   docker-compose down"
echo ""
echo "Note: You may need to log out and back in for Docker group changes to take effect."
echo "=========================================="
