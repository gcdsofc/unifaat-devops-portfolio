output "state_bucket_name" {
  description = "Nome do bucket S3 usado para remote state."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "lock_table_name" {
  description = "Nome da tabela DynamoDB usada para locking."
  value       = aws_dynamodb_table.terraform_locks.name
}

output "backend_config_example" {
  description = "Bloco backend esperado pelo projeto principal."
  value       = "bucket=${aws_s3_bucket.terraform_state.bucket}, key=aula-05/main/terraform.tfstate, region=${var.aws_region}, dynamodb_table=${aws_dynamodb_table.terraform_locks.name}, encrypt=true"
}
