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

# Data source to get the latest Redis AMI (fallback if not provided)
data "aws_ami" "redis" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["myapp-redis-v*"]
  }
}

# Security group for Redis
resource "aws_security_group" "redis" {
  name        = "redis-sg-${var.environment}"
  description = "Security group for Redis API service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.service_port
    to_port     = var.service_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Redis API port"
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Redis server port"
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

  user_data = <<-EOF
    #!/bin/bash
    # Create environment file with Eureka URL from SSM
    cat > /opt/redis/redis.env << 'ENVEOF'
    EUREKA_URL=${var.eureka_url}
    SERVER_PORT=${var.service_port}
    SPRING_APP_NAME=redis
    EUREKA_CLIENT_REGISTER_WITH_EUREKA=true
    EUREKA_CLIENT_FETCH_REGISTRY=true
    EUREKA_INSTANCE_PREFER_IP_ADDRESS=true
    ENVEOF
    
    # Set proper permissions
    chown redis:redis /opt/redis/redis.env 2>/dev/null || true
    chmod 600 /opt/redis/redis.env 2>/dev/null || true
    
    # Create systemd override directory
    mkdir -p /etc/systemd/system/redis.service.d
    
    # Create override config to load environment file
    cat > /etc/systemd/system/redis.service.d/override.conf << 'SYSTEMDEOF'
    [Service]
    EnvironmentFile=/opt/redis/redis.env
    SYSTEMDEOF
    
    # Reload systemd and restart service
    systemctl daemon-reload
    systemctl restart redis
    
    echo "Redis configured with Eureka URL: ${var.eureka_url}"
  EOF

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

