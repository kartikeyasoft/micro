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

resource "aws_instance" "service1" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.service1.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.service1.id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    # Create environment file with Eureka URL from SSM
    cat > /opt/service1/service1.env << 'ENVEOF'
    EUREKA_URL=${var.eureka_url}
    SERVER_PORT=${var.service_port}
    SPRING_APP_NAME=service1
    DB_URL=${var.db_url}
    DB_USER=${var.db_username}
    DB_PASSWORD=${var.db_password}
    ENVEOF
    
    # Set proper permissions
    chown service1:service1 /opt/service1/service1.env
    chmod 600 /opt/service1/service1.env
    
    # Create systemd override directory
    mkdir -p /etc/systemd/system/service1.service.d
    
    # Create override config to load environment file
    cat > /etc/systemd/system/service1.service.d/override.conf << 'SYSTEMDEOF'
    [Service]
    EnvironmentFile=/opt/service1/service1.env
    SYSTEMDEOF
    
    # Reload systemd and restart service
    systemctl daemon-reload
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
