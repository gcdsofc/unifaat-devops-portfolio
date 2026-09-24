output "vpc_id" {
  description = "ID da VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID da subnet publica."
  value       = aws_subnet.public.id
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas usadas pelo RDS."
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "ec2_public_ip" {
  description = "IP publico da EC2."
  value       = aws_instance.api.public_ip
}

output "rds_endpoint" {
  description = "Endpoint completo do RDS."
  value       = aws_db_instance.postgres.endpoint
}

output "rds_address" {
  description = "Endereco DNS do RDS."
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "Porta do RDS."
  value       = aws_db_instance.postgres.port
}

output "connection_string" {
  description = "Comando psql para conectar ao RDS a partir da EC2."
  value       = "psql -h ${aws_db_instance.postgres.address} -U ${var.db_username} -d ${var.db_name} -p ${aws_db_instance.postgres.port}"
}

output "ssh_command" {
  description = "Comando SSH para acessar a EC2."
  value       = "ssh -i ~/.ssh/technova-key ec2-user@${aws_instance.api.public_ip}"
}
