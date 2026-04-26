# Outputs
output "service2_public_ip" {
  description = "Public IP of Service2 instance"
  value       = aws_instance.service2.public_ip
}

output "service2_private_ip" {
  description = "Private IP of Service2 instance"
  value       = aws_instance.service2.private_ip
}