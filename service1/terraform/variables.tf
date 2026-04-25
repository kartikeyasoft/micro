# Required variables (with defaults for destroy)
variable "ami_id" {
  description = "Service1 AMI ID"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
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
  description = "Subnet ID"
  type        = string
  default     = "subnet-0aa31e769c8f4d73e"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-0cb7deb47a6bfa727"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "ksansible"
}

# Service-specific variables
variable "eureka_url" {
  description = "Eureka server URL"
  type        = string
  default     = ""
}

variable "db_url" {
  description = "Database URL"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = ""
  sensitive   = true
}