packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Read variables from Ansible YAML file
locals {
  # This requires yamldecode function (Packer 1.7+)
  ansible_vars = yamldecode(file("./ansible/vars/ami.yml"))
}

variable "service_name" {
  type    = string
  default = local.ansible_vars.service_name  # Read from Ansible vars
}

variable "service_version" {
  type    = string
  default = "1.0.0"  # Still need to pass from Jenkins
}

variable "source_ami" {
  type    = string
  default = "ami-0c7217bde2a952dfe"
}

source "amazon-ebs" "custom-ami" {
  ami_name        = "${var.service_name}-${var.service_version}-{{timestamp}}"
  instance_type   = "t3.micro"
  region          = "us-east-1"
  source_ami      = var.source_ami
  ssh_username    = "ubuntu"
  
  tags = {
    Name        = "${var.service_name}-v${var.service_version}"
    Service     = var.service_name
    Version     = var.service_version
    CreatedBy   = "Packer"
  }
}

build {
  sources = ["source.amazon-ebs.custom-ami"]

  provisioner "ansible" {
    playbook_file   = "./ansible/playbook-ami.yml"
    extra_arguments = ["--verbose"]
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False"
    ]
  }
}