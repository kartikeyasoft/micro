output "gateway_public_ip" {
  description = "Public IP of Gateway instance"
  value       = aws_instance.gateway.public_ip
}

output "gateway_private_ip" {
  description = "Private IP of Gateway instance"
  value       = aws_instance.gateway.private_ip
}

output "gateway_dashboard_url" {
  description = "Gateway API URL"
  value       = "http://${aws_instance.gateway.public_ip}:${var.service_port}"
}