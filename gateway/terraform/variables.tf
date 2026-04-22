variable "ami_id" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "eureka_url" {
  type    = string
  default = "http://localhost:8761/eureka/"
}

variable "db_url" {
  type    = string
  default = "jdbc:mysql://172.21.12.151:3306/exam?useSSL=false&serverTimezone=UTC"
}

variable "db_username" {
  type    = string
  default = "Admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "service1_url" {
  type    = string
  default = "http://localhost:9001"
}

variable "service2_url" {
  type    = string
  default = "http://localhost:9002"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type    = string
  default = "subnet-0aa31e769c8f4d73e"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0cb7deb47a6bfa727"
}

variable "key_name" {
  type    = string
  default = "ksansible"
}