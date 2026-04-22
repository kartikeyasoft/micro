output "service1_public_ip" {
  value = aws_instance.service1.public_ip
}

output "service1_private_ip" {
  value = aws_instance.service1.private_ip
}

output "service1_api_url" {
  value = "http://${aws_instance.service1.public_ip}:9001"
}