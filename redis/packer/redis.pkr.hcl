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
variable "service_name" {
  type = string
}

variable "service_version" {
  type = string
}

variable "service_port" {
  type    = string
  default = "1222"
}

variable "nexus_url" {
  type = string
}

variable "eureka_port" {
  type    = string
  default = "8761"
}

# Source AMI
source "amazon-ebs" "redis" {
  ami_name        = "myapp-${var.service_name}-v${var.service_version}"
  instance_type   = "t3.micro"
  region          = "us-east-1"
  source_ami      = "ami-0c7217cdde317cfec"  # Ubuntu 22.04
  ssh_username    = "ubuntu"
}

# Build
build {
  sources = ["source.amazon-ebs.redis"]

  provisioner "ansible" {
    playbook_file = "./ansible/playbook-redis.yml"
    ansible_env_vars = [
      "SERVICE_NAME=${var.service_name}",
      "SERVICE_VERSION=${var.service_version}",
      "SERVICE_PORT=${var.service_port}",
      "NEXUS_URL=${var.nexus_url}",
      "EUREKA_PORT=${var.eureka_port}"
    ]
  }
}