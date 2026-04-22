output "gateway_public_ip" {
  value = aws_instance.gateway.public_ip
}

output "gateway_private_ip" {
  value = aws_instance.gateway.private_ip
}

output "gateway_api_url" {
  value = "http://${aws_instance.gateway.public_ip}:8080"
}