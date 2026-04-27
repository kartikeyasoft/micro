variable "service_name" {
  type = string
}

variable "service_version" {
  type = string
}

variable "source_ami" {
  type = string
}

variable "aws_region" {
  type = string
}

source "amazon-ebs" "ami" {
  ami_name      = "${var.service_name}-${var.service_version}-{{timestamp}}"
  instance_type = "t3.micro"
  region        = var.aws_region
  source_ami    = var.source_ami
  ssh_username  = "ubuntu"
  
  tags = {
    Name    = "${var.service_name}-${var.service_version}"
    Service = var.service_name
    Version = var.service_version
  }
}

build {
  sources = ["source.amazon-ebs.ami"]

  provisioner "ansible" {
    playbook_file = "./ansible/playbook-ami.yml"
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False"
    ]
  }
}