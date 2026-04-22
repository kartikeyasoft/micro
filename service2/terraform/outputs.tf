output "service2_instance_id" {
  description = "ID of the Service2 EC2 instance"
  value       = aws_instance.service2.id
}

output "service2_public_ip" {
  description = "Public IP of Service2 instance"
  value       = aws_instance.service2.public_ip
}

output "service2_private_ip" {
  description = "Private IP of Service2 instance"
  value       = aws_instance.service2.private_ip
}

output "service2_api_url" {
  description = "URL to access Service2 API"
  value       = "http://${aws_instance.service2.public_ip}:9002"
}

output "service2_health_url" {
  description = "Health check URL for Service2"
  value       = "http://${aws_instance.service2.public_ip}:9002/actuator/health"
}

output "used_ami_id" {
  description = "AMI ID used for deployment"
  value       = var.ami_id != "" ? var.ami_id : data.aws_ami.service2.id
}

output "security_group_id" {
  description = "Security group ID used for Service2"
  value       = aws_security_group.service2.id
}