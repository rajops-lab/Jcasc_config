# Jenkins Configuration as Code (JCasC) Setup

This repository contains a complete Jenkins Configuration as Code setup for deployment on EC2 Ubuntu instances using Docker and Docker Compose.

## 📁 Repository Structure

```
Jcasc_config/
├── Jenkins/
│   ├── Dockerfile              # Custom Jenkins image with tools
│   ├── plugins.txt             # Jenkins plugins list
│   └── casc/
│       └── jenkins.yaml        # JCasC configuration
├── docker-compose.yml          # Container orchestration
├── env.example                 # Environment variables template
├── setup-jenkins.sh           # EC2 setup script
└── README.md                  # This file
```

## 🚀 Quick Start on EC2 Ubuntu

### Prerequisites
- EC2 Ubuntu instance (t3.medium or larger recommended)
- Security group allowing ports 8080 (Jenkins) and 22 (SSH)
- Internet access for downloading packages

### 1. Connect to your EC2 instance
```bash
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```

### 2. Run the setup script
```bash
# Download and run the setup script
curl -fsSL https://raw.githubusercontent.com/rajops-lab/Jcasc_config/main/setup-jenkins.sh -o setup-jenkins.sh
chmod +x setup-jenkins.sh
./setup-jenkins.sh
```

### 3. Configure environment variables
```bash
cd ~/jenkins-setup/Jcasc_config
nano .env
```

Edit the following variables in `.env`:
```bash
# Required
JENKINS_ADMIN_ID=admin
JENKINS_ADMIN_PASSWORD=your-secure-password
JENKINS_ADMIN_EMAIL=admin@yourcompany.com
JENKINS_URL=http://your-ec2-public-ip:8080

# GitHub Integration
GITHUB_USERNAME=your-github-username
GITHUB_TOKEN=your-github-personal-access-token

# AWS Credentials
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
```

### 4. Start Jenkins
```bash
docker-compose up -d
```

### 5. Access Jenkins
Open your browser and navigate to:
```
http://your-ec2-public-ip:8080
```

Login with the credentials you set in the `.env` file.

## 🛠️ Manual Setup (Alternative)

If you prefer manual setup:

### 1. Install Docker and Docker Compose
```bash
# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 2. Clone this repository
```bash
git clone https://github.com/rajops-lab/Jcasc_config.git
cd Jcasc_config
```

### 3. Configure and start
```bash
cp env.example .env
# Edit .env with your values
docker-compose up -d
```

## 🔧 Configuration Details

### Jenkins Plugins
The `Jenkins/plugins.txt` file includes:
- **Critical**: workflow-aggregator, job-dsl, git, github, docker-workflow
- **High Priority**: credentials-binding
- **Medium Priority**: nodejs, htmlpublisher
- **Low Priority**: build-monitor-plugin, timestamper
- **Dependencies**: All required supporting plugins

### JCasC Configuration
The `Jenkins/casc/jenkins.yaml` includes:
- Security configuration with local users
- Docker cloud configuration
- Global tools (Git, Maven, JDK)
- Credential management
- Shared library configuration
- Timestamper and build step operations

### Docker Image Features
The custom Jenkins image includes:
- Jenkins LTS with JDK 17
- Docker CLI and Docker Compose
- AWS CLI v2
- kubectl
- Terraform
- Python 3 and pip
- Git, curl, wget, jq

## 📊 Management Commands

### View logs
```bash
docker-compose logs -f jenkins
```

### Restart Jenkins
```bash
docker-compose restart jenkins
```

### Stop Jenkins
```bash
docker-compose down
```

### Update Jenkins
```bash
docker-compose pull
docker-compose up -d
```

### Backup Jenkins data
```bash
docker run --rm -v jenkins_home:/data -v $(pwd):/backup alpine tar czf /backup/jenkins-backup.tar.gz -C /data .
```

### Restore Jenkins data
```bash
docker run --rm -v jenkins_home:/data -v $(pwd):/backup alpine tar xzf /backup/jenkins-backup.tar.gz -C /data
```

## 🔐 Security Considerations

1. **Change default passwords** in the `.env` file
2. **Use strong passwords** for Jenkins admin account
3. **Restrict security group** to only necessary IPs
4. **Enable HTTPS** in production (requires SSL certificates)
5. **Regular updates** of Jenkins and plugins
6. **Backup regularly** using the backup commands above

## 🐛 Troubleshooting

### Jenkins won't start
```bash
# Check logs
docker-compose logs jenkins

# Check if ports are available
sudo netstat -tlnp | grep :8080
```

### Permission issues
```bash
# Fix Docker permissions
sudo chown -R $USER:$USER ~/jenkins-setup
sudo chmod -R 755 ~/jenkins-setup
```

### Plugin installation issues
```bash
# Rebuild Jenkins image
docker-compose build --no-cache jenkins
docker-compose up -d
```

### Memory issues
```bash
# Increase memory in docker-compose.yml
environment:
  - JAVA_OPTS=-Xmx4096m -Xms2048m
```

## 📝 Environment Variables Reference

| Variable | Description | Required |
|----------|-------------|----------|
| `JENKINS_ADMIN_ID` | Jenkins admin username | Yes |
| `JENKINS_ADMIN_PASSWORD` | Jenkins admin password | Yes |
| `JENKINS_ADMIN_EMAIL` | Jenkins admin email | Yes |
| `JENKINS_URL` | Jenkins URL (with EC2 public IP) | Yes |
| `GITHUB_USERNAME` | GitHub username for integration | Yes |
| `GITHUB_TOKEN` | GitHub personal access token | Yes |
| `AWS_ACCESS_KEY_ID` | AWS access key | Yes |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key | Yes |
| `DOCKER_REGISTRY_USERNAME` | Docker registry username | No |
| `DOCKER_REGISTRY_PASSWORD` | Docker registry password | No |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the configuration
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For issues and questions:
- Create an issue in this repository
- Check the troubleshooting section above
- Review Jenkins and Docker documentation
