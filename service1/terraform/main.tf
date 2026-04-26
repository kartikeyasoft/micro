terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source to get the latest Service1 AMI (fallback if not provided)
data "aws_ami" "service1" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["myapp-service1-v*"]
  }
}

# Security group for Service1
resource "aws_security_group" "service1" {
  name        = "service1-sg-${var.environment}"
  description = "Security group for Service1"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.service_port
    to_port     = var.service_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Service1 API port"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "service1-sg-${var.environment}"
    Environment = var.environment
    Service     = "service1"
  }
}

# EC2 Instance
resource "aws_instance" "service1" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.service1.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.service1.id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    # Replace PLACEHOLDER with actual Eureka URL
    sed -i 's|PLACEHOLDER|${var.eureka_url}|g' /opt/service1/service1.env
    # Restart service to pick up new configuration
    systemctl restart service1
    echo "Service1 configured with Eureka URL: ${var.eureka_url}"
  EOF

  tags = {
    Name        = "service1-${var.environment}"
    Environment = var.environment
    Service     = "service1"
    ManagedBy   = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Outputs
output "service1_public_ip" {
  description = "Public IP of Service1 instance"
  value       = aws_instance.service1.public_ip
}

output "service1_private_ip" {
  description = "Private IP of Service1 instance"
  value       = aws_instance.service1.private_ip
}

output "service1_security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.service1.id
}