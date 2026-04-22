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

# Data source to get the latest Service2 AMI
data "aws_ami" "service2" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["myapp-service2-v*"]
  }
}

# Security Group for Service2
resource "aws_security_group" "service2" {
  name        = "service2-sg-${var.environment}"
  description = "Security group for Service2"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 9002
    to_port     = 9002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Service2 API"
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
    Name        = "service2-sg-${var.environment}"
    Environment = var.environment
    Service     = "service2"
  }
}

# EC2 Instance for Service2
resource "aws_instance" "service2" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.service2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.service2.id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    echo "Service2 instance started"
    # Optional: Add any initialization scripts here
  EOF

  tags = {
    Name        = "service2-${var.environment}"
    Environment = var.environment
    Service     = "service2"
    ManagedBy   = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP (Optional)
resource "aws_eip" "service2" {
  count    = var.assign_eip ? 1 : 0
  instance = aws_instance.service2.id
  domain   = "vpc"

  tags = {
    Name        = "service2-eip-${var.environment}"
    Environment = var.environment
  }
}