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

# Data source to get the latest RabbitMQ AMI (fallback if not provided)
data "aws_ami" "rabbitmq" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["myapp-rabbitmq-v*"]
  }
}

# Security group for RabbitMQ
resource "aws_security_group" "rabbitmq" {
  name        = "rabbitmq-sg-${var.environment}"
  description = "Security group for RabbitMQ API service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.service_port
    to_port     = var.service_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "RabbitMQ API port"
  }

  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "RabbitMQ server port"
  }

  ingress {
    from_port   = 15672
    to_port     = 15672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "RabbitMQ management UI"
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
    Name        = "rabbitmq-sg-${var.environment}"
    Environment = var.environment
    Service     = "rabbitmq"
  }
}

# EC2 Instance
resource "aws_instance" "rabbitmq" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.rabbitmq.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.rabbitmq.id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    # Create environment file with Eureka URL from SSM
    cat > /opt/rabbitmq/rabbitmq.env << 'ENVEOF'
    EUREKA_URL=${var.eureka_url}
    SERVER_PORT=${var.service_port}
    SPRING_APP_NAME=rabbitmq
    REDIS_SERVICE_URL=${var.redis_url}
    EUREKA_CLIENT_REGISTER_WITH_EUREKA=true
    EUREKA_CLIENT_FETCH_REGISTRY=true
    EUREKA_INSTANCE_PREFER_IP_ADDRESS=true
    ENVEOF
    
    # Set proper permissions
    chown rabbitmq:rabbitmq /opt/rabbitmq/rabbitmq.env 2>/dev/null || true
    chmod 600 /opt/rabbitmq/rabbitmq.env 2>/dev/null || true
    
    # Create systemd override directory
    mkdir -p /etc/systemd/system/rabbitmq.service.d
    
    # Create override config to load environment file
    cat > /etc/systemd/system/rabbitmq.service.d/override.conf << 'SYSTEMDEOF'
    [Service]
    EnvironmentFile=/opt/rabbitmq/rabbitmq.env
    SYSTEMDEOF
    
    # Reload systemd and restart service
    systemctl daemon-reload
    systemctl restart rabbitmq
    
    echo "RabbitMQ configured with Eureka URL: ${var.eureka_url}"
    echo "RabbitMQ configured with Redis URL: ${var.redis_url}"
  EOF

  tags = {
    Name        = "rabbitmq-${var.environment}"
    Environment = var.environment
    Service     = "rabbitmq"
    ManagedBy   = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

