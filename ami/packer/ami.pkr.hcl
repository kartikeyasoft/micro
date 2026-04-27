packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "service_name" {
  type = string
}

variable "service_version" {
  type = string
}

variable "source_ami" {
  description = "Base AMI ID to use for the build"
  type        = string
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
    Environment = "production"
  }
}

build {
  sources = ["source.amazon-ebs.custom-ami"]

  provisioner "ansible" {
    playbook_file   = "./ansible/playbook-ami.yml"
    extra_arguments = ["--verbose"]
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_SSH_RETRIES=3"
    ]
  }
}