output "redis_instance_id" {
  description = "ID of the Redis EC2 instance"
  value       = aws_instance.redis.id
}

output "redis_public_ip" {
  description = "Public IP of Redis instance"
  value       = aws_instance.redis.public_ip
}

output "redis_private_ip" {
  description = "Private IP of Redis instance"
  value       = aws_instance.redis.private_ip
}

output "redis_api_url" {
  description = "URL to access Redis API"
  value       = "http://${aws_instance.redis.public_ip}:1222"
}

output "used_ami_id" {
  description = "AMI ID used for deployment"
  value       = var.ami_id != "" ? var.ami_id : data.aws_ami.redis.id
}

output "security_group_id" {
  description = "Security group ID used for Redis"
  value       = aws_security_group.redis.id
}
