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

# Data source to get the latest Gateway AMI (fallback if not provided)
data "aws_ami" "gateway" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["myapp-gateway-v*"]
  }
}

# Security group for Gateway
resource "aws_security_group" "gateway" {
  name        = "gateway-sg-${var.environment}"
  description = "Security group for API Gateway"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.service_port
    to_port     = var.service_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Gateway API port"
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

# EC2 Instance
resource "aws_instance" "gateway" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.gateway.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.gateway.id]
  key_name               = var.key_name

user_data = <<-EOF
  #!/bin/bash
  # Create environment file
  cat > /opt/gateway/gateway.env << 'ENVEOF'
  EUREKA_URL=${var.eureka_url}
  SERVER_PORT=8080
  SPRING_APP_NAME=gateway
  EUREKA_CLIENT_REGISTER_WITH_EUREKA=true
  EUREKA_CLIENT_FETCH_REGISTRY=true
  EUREKA_INSTANCE_PREFER_IP_ADDRESS=true
  ENVEOF
  
  # Also add to /etc/environment for system-wide availability
  echo "EUREKA_URL=${var.eureka_url}" >> /etc/environment
  
  chown gateway:gateway /opt/gateway/gateway.env
  chmod 600 /opt/gateway/gateway.env
  
  # Create systemd override
  mkdir -p /etc/systemd/system/gateway.service.d
  cat > /etc/systemd/system/gateway.service.d/override.conf << 'SYSTEMDEOF'
  [Service]
  EnvironmentFile=/opt/gateway/gateway.env
  SYSTEMDEOF
  
  systemctl daemon-reload
  systemctl restart gateway
EOF