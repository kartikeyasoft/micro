output "service1_public_ip" {
  description = "Public IP of Service1 instance"
  value       = aws_instance.service1.public_ip
}

output "service1_private_ip" {
  description = "Private IP of Service1 instance"
  value       = aws_instance.service1.private_ip
}

output "service1_security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.service1.id
}