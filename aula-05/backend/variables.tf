variable "aws_region" {
  description = "Regiao AWS usada no AWS Academy Learner Lab."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3 para remote state."
  type        = string
  default     = "technova-tfstate-6325300-aula05"
}

variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB usada para lock do Terraform."
  type        = string
  default     = "technova-terraform-locks-6325300-aula05"
}

variable "owner_ra" {
  description = "RA do aluno responsavel."
  type        = string
  default     = "6325300"
}
