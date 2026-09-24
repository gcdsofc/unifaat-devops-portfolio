output "vpc_id" {
  description = "ID da VPC dev."
  value       = module.vpc.vpc_id
}

output "api_public_ip" {
  description = "IP publico da API dev."
  value       = module.api_server.public_ip
}

output "rds_endpoint" {
  description = "Endpoint do RDS dev."
  value       = module.database.db_endpoint
}
