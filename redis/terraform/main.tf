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

# Data source to get the latest Redis AMI
data "aws_ami" "redis" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["myapp-redis-v*"]
  }
}

# Create security group for Redis
resource "aws_security_group" "redis" {
  name        = "redis-sg-${var.environment}"
  description = "Security group for Redis service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 1222
    to_port     = 1222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Redis API"
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
    Name        = "redis-sg-${var.environment}"
    Environment = var.environment
    Service     = "redis"
  }
}

# EC2 Instance
resource "aws_instance" "redis" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.redis.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.redis.id]
  key_name               = var.key_name

  tags = {
    Name        = "redis-${var.environment}"
    Environment = var.environment
    Service     = "redis"
    ManagedBy   = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP (Optional)
resource "aws_eip" "redis" {
  count    = var.assign_eip ? 1 : 0
  instance = aws_instance.redis.id
  domain   = "vpc"

  tags = {
    Name        = "redis-eip-${var.environment}"
    Environment = var.environment
  }
}
