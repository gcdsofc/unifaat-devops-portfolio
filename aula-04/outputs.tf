output "vpc_id" {
  description = "ID da VPC criada."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs das subnets publicas."
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas."
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "api_security_group_id" {
  description = "ID do Security Group da API."
  value       = aws_security_group.api.id
}

output "db_security_group_id" {
  description = "ID do Security Group do banco."
  value       = aws_security_group.database.id
}

output "ec2_public_ip" {
  description = "IP publico da instancia EC2."
  value       = aws_instance.api.public_ip
}

output "api_url" {
  description = "URL publica da API."
  value       = "http://${aws_instance.api.public_ip}:3000"
}

output "ssh_command" {
  description = "Comando SSH para acessar a instancia."
  value       = "ssh -i ~/.ssh/technova-key ec2-user@${aws_instance.api.public_ip}"
}
