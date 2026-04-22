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

variable "service_name" {
  type = string
}

variable "service_version" {
  type = string
}

variable "nexus_url" {
  type = string
}

source "amazon-ebs" "rabbitmq" {
  ami_name        = "myapp-${var.service_name}-v${var.service_version}"
  instance_type   = "t3.micro"
  region          = "us-east-1"
  source_ami      = "ami-0c7217cdde317cfec"
  ssh_username    = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.rabbitmq"]

  provisioner "ansible" {
    playbook_file = "./ansible/playbook-rabbitmq.yml"
    ansible_env_vars = [
      "SERVICE_NAME=${var.service_name}",
      "SERVICE_VERSION=${var.service_version}",
      "NEXUS_URL=${var.nexus_url}"
    ]
  }
}
