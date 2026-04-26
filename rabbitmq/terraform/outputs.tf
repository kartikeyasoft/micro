output "rabbitmq_public_ip" {
  description = "Public IP of RabbitMQ instance"
  value       = aws_instance.rabbitmq.public_ip
}

output "rabbitmq_private_ip" {
  description = "Private IP of RabbitMQ instance"
  value       = aws_instance.rabbitmq.private_ip
}

output "rabbitmq_api_url" {
  description = "RabbitMQ API URL"
  value       = "http://${aws_instance.rabbitmq.public_ip}:${var.service_port}"
}

output "rabbitmq_management_url" {
  description = "RabbitMQ Management UI URL"
  value       = "http://${aws_instance.rabbitmq.public_ip}:15672"
}

output "used_ami_id" {
  description = "AMI ID used for deployment"
  value       = var.ami_id != "" ? var.ami_id : data.aws_ami.rabbitmq.id
}