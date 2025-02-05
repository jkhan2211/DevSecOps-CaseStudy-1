#!/bin/bash

# Install Updated packages on linux machine
sudo dnf update -y

# Add Jenkins repo
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Java 17
sudo dnf install java-17-amazon-corretto-devel -y

# Install Jenkins
sudo dnf install jenkins -y

# Configure Jenkins port
sudo sed -i -e 's/Environment="JENKINS_PORT=[0-9]\+"/Environment="JENKINS_PORT=8081"/' /usr/lib/systemd/system/jenkins.service

# Start Jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install other tools
sudo dnf install git -y
sudo dnf install nodejs npm -y

# Install Maven
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo dnf install -y apache-maven

# Set Java version
sudo update-alternatives --set java /usr/lib/jvm/java-17-amazon-corretto.x86_64/bin/java

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
sudo dnf install unzip -y
sudo unzip awscliv2.zip  
sudo ./aws/install

# Install ZAP
sudo wget https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2_14_0_unix.sh
sudo chmod +x ZAP_2_14_0_unix.sh 
sudo ./ZAP_2_14_0_unix.sh -q

# Install kubectl
curl -o kubectl https://s3.us-east-1.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
sudo cp kubectl /usr/local/bin/

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Install and configure Docker
sudo dnf install docker -y
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins
sudo systemctl enable docker
sudo systemctl start docker

# Install jq
sudo dnf install jq -y

# Final Jenkins restart to ensure all changes are applied
sudo systemctl restart jenkins
