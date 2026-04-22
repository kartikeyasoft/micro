variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  default = "production"
}

variable "ami_id" {
  default = ""
}

variable "instance_type" {
  default = "t3.micro"
}

variable "subnet_id" {
  default = "subnet-0aa31e769c8f4d73e"
}

variable "vpc_id" {
  default = "vpc-0cb7deb47a6bfa727"
}

variable "key_name" {
  default = "ksansible"
}