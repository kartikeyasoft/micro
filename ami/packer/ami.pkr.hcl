packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "service_name" { type = string }
variable "service_version" { type = string }
variable "source_ami" { type = string }
variable "aws_region" { type = string }

source "amazon-ebs" "ami" {
  ami_name      = "${var.service_name}-${var.service_version}"
  instance_type = "t3.micro"
  region        = var.aws_region
  source_ami    = var.source_ami
  ssh_username  = "ubuntu"
  ssh_timeout   = "10m"
}

build {
  sources = ["source.amazon-ebs.ami"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y curl wget unzip jq net-tools mysql-client openjdk-17-jre-headless",
      "cd /tmp && curl -s 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' && unzip -q awscliv2.zip && sudo ./aws/install && rm -rf aws awscliv2.zip",
      "echo 'Installation completed!'"
    ]
  }
}