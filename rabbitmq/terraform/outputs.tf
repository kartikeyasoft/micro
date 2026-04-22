output "rabbitmq_public_ip" {
  value = aws_instance.rabbitmq.public_ip
}

output "rabbitmq_private_ip" {
  value = aws_instance.rabbitmq.private_ip
}

output "rabbitmq_api_url" {
  value = "http://${aws_instance.rabbitmq.public_ip}:8001"
}
