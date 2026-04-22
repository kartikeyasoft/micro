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

data "aws_ami" "gateway" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["myapp-gateway-v*"]
  }
}

resource "aws_security_group" "gateway" {
  name        = "gateway-sg-${var.environment}"
  description = "Security group for API Gateway"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Gateway API"
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
    Name        = "gateway-sg-${var.environment}"
    Environment = var.environment
    Service     = "gateway"
  }
}

resource "aws_instance" "gateway" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.gateway.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.gateway.id]
  key_name               = var.key_name

  tags = {
    Name        = "gateway-${var.environment}"
    Environment = var.environment
    Service     = "gateway"
    ManagedBy   = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}