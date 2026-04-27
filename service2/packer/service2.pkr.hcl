packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# Variables
variable "service_name" { type = string }
variable "service_version" { type = string }
variable "service_port" { type = string }
variable "nexus_url" { type = string }
variable "db_host" { type = string }
variable "db_port" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string }
variable "eureka_ip" { type = string }
variable "eureka_port" { type = string }
variable "source_ami" { type = string }

# Source AMI - Creates a NEW custom AMI
source "amazon-ebs" "service2" {
  ami_name        = "myapp-${var.service_name}-v${var.service_version}-{{timestamp}}"
  instance_type   = "t3.micro"
  region          = "us-east-1"
  source_ami      = var.source_ami
  ssh_username    = "ubuntu"
  ssh_timeout     = "10m"
  
  tags = {
    Name        = "myapp-${var.service_name}-v${var.service_version}"
    Service     = var.service_name
    Version     = var.service_version
    SourceAMI   = var.source_ami
    BuiltBy     = "Packer"
    BuildDate   = "{{timestamp}}"
  }
}

# Build
build {
  sources = ["source.amazon-ebs.service2"]

  provisioner "ansible" {
    playbook_file = "./ansible/playbook-service2.yml"
    ansible_env_vars = [
      "SERVICE_NAME=${var.service_name}",
      "SERVICE_VERSION=${var.service_version}",
      "SERVICE_PORT=${var.service_port}",
      "NEXUS_URL=${var.nexus_url}",
      "DB_HOST=${var.db_host}",
      "DB_PORT=${var.db_port}",
      "DB_NAME=${var.db_name}",
      "DB_USERNAME=${var.db_username}",
      "DB_PASSWORD=${var.db_password}",
      "EUREKA_IP=${var.eureka_ip}",
      "EUREKA_PORT=${var.eureka_port}"
    ]
  }
}