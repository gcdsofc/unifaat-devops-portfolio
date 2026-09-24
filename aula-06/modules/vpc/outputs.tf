output "vpc_id" {
  description = "ID da VPC criada."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs das subnets publicas."
  value       = [for name, subnet in aws_subnet.this : subnet.id if var.subnets[name].type == "public"]
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas."
  value       = [for name, subnet in aws_subnet.this : subnet.id if var.subnets[name].type == "private"]
}

output "subnet_id_map" {
  description = "Mapa nome => ID de todas as subnets."
  value       = { for name, subnet in aws_subnet.this : name => subnet.id }
}
