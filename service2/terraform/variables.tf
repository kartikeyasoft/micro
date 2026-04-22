variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "production"
}

variable "ami_id" {
  description = "Service2 AMI ID (leave empty to use latest)"
  type        = string
  default     = ""
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

variable "db_host" {
  description = "Database host address"
  type        = string
  default     = "172.21.12.151"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "exam"
}

variable "db_user" {
  description = "Database username"
  type        = string
  default     = "Admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "Admin@123"
  sensitive   = true
}

variable "eureka_url" {
  description = "Eureka server URL"
  type        = string
  default     = "http://192.168.29.63:8761/eureka/"
}