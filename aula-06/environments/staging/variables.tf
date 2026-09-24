variable "aws_region" {
  description = "Regiao AWS."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto."
  type        = string
  default     = "technova"
}

variable "environment" {
  description = "Nome do ambiente."
  type        = string
  default     = "staging"
}

variable "owner_ra" {
  description = "RA do aluno."
  type        = string
  default     = "6325300"
}

variable "ami_id" {
  description = "AMI Amazon Linux 2023 para o ambiente."
  type        = string
  default     = "ami-0c101f26f147fa7fd"
}

variable "key_name" {
  description = "Key Pair usado pela EC2."
  type        = string
  default     = "technova-key"
}

variable "db_password" {
  description = "Senha do RDS para laboratorio."
  type        = string
  sensitive   = true
  default     = "StagingChangeMe6325300"
}
