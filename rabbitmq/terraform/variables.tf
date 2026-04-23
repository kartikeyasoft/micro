variable "ami_id" {
  description = "RabbitMQ Backend AMI ID"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "eureka_url" {
  description = "Eureka server URL"
  type        = string
  default     = "http://localhost:8761/eureka/"
}

variable "redis_service_url" {
  description = "Redis Service URL"
  type        = string
  default     = "http://localhost:1222/redis"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
  default     = "subnet-0aa31e769c8f4d73e"
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
  default     = "vpc-0cb7deb47a6bfa727"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "ksansible"
}

variable "assign_eip" {
  description = "Assign Elastic IP to instance"
  type        = bool
  default     = false
}