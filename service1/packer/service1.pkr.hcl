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

source "amazon-ebs" "service1" {
  ami_name        = "myapp-${var.service_name}-v${var.service_version}"
  instance_type   = "t3.micro"
  region          = "us-east-1"
  source_ami      = "ami-0c7217cdde317cfec"
  ssh_username    = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.service1"]

  provisioner "ansible" {
    playbook_file = "./ansible/playbook-service1.yml"
    ansible_env_vars = [
      "SERVICE_NAME=${var.service_name}",
      "SERVICE_VERSION=${var.service_version}",
      "NEXUS_URL=${var.nexus_url}"
    ]
  }

  # Cleanup provisioner - CRITICAL for clean AMI
  provisioner "shell" {
    inline = [
      "echo '========== STARTING LOG CLEANUP =========='",
      "sudo journalctl --rotate",
      "sudo journalctl --vacuum-time=1s",
      "sudo rm -rf /var/log/journal/*",
      "sudo truncate -s 0 /var/log/syslog 2>/dev/null || true",
      "sudo truncate -s 0 /var/log/auth.log 2>/dev/null || true",
      "sudo truncate -s 0 /var/log/cloud-init.log 2>/dev/null || true",
      "sudo truncate -s 0 /var/log/cloud-init-output.log 2>/dev/null || true",
      "sudo rm -f /root/.bash_history",
      "sudo rm -f /home/ubuntu/.bash_history",
      "sudo rm -rf /tmp/*",
      "sudo apt-get clean",
      "echo '========== LOG CLEANUP COMPLETED =========='"
    ]
  }
}