output "vpc_id" {
  description = "ID da VPC staging."
  value       = module.vpc.vpc_id
}

output "api_public_ip" {
  description = "IP publico da API staging."
  value       = module.api_server.public_ip
}

output "rds_endpoint" {
  description = "Endpoint do RDS staging."
  value       = module.database.db_endpoint
}
