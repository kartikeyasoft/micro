output "redis_public_ip" {
  description = "Public IP of Redis instance"
  value       = aws_instance.redis.public_ip
}

output "redis_private_ip" {
  description = "Private IP of Redis instance"
  value       = aws_instance.redis.private_ip
}

output "redis_api_url" {
  description = "Redis API URL"
  value       = "http://${aws_instance.redis.public_ip}:${var.service_port}"
}

output "used_ami_id" {
  description = "AMI ID used for deployment"
  value       = var.ami_id != "" ? var.ami_id : data.aws_ami.redis.id
}