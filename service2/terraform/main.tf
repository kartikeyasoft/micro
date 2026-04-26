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

# Data source to get the latest Service2 AMI (fallback if not provided)
data "aws_ami" "service2" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["myapp-service2-v*"]
  }
}

# Security group for Service2
resource "aws_security_group" "service2" {
  name        = "service2-sg-${var.environment}"
  description = "Security group for Service2"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.service_port
    to_port     = var.service_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Service2 API port"
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

# EC2 Instance
resource "aws_instance" "service2" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.service2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.service2.id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    # Create environment file with Eureka URL from SSM
    cat > /opt/service2/service2.env << 'ENVEOF'
    EUREKA_URL=${var.eureka_url}
    SERVER_PORT=${var.service_port}
    SPRING_APP_NAME=service2
    DB_URL=${var.db_url}
    DB_USER=${var.db_username}
    DB_PASSWORD=${var.db_password}
    ENVEOF
    
    # Set proper permissions
    chown service2:service2 /opt/service2/service2.env 2>/dev/null || true
    chmod 600 /opt/service2/service2.env 2>/dev/null || true
    
    # Create systemd override directory
    mkdir -p /etc/systemd/system/service2.service.d
    
    # Create override config to load environment file
    cat > /etc/systemd/system/service2.service.d/override.conf << 'SYSTEMDEOF'
    [Service]
    EnvironmentFile=/opt/service2/service2.env
    SYSTEMDEOF
    
    # Reload systemd and restart service
    systemctl daemon-reload
    systemctl restart service2
    
    echo "Service2 configured with Eureka URL: ${var.eureka_url}"
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

