variable "aws_region" {
  description = "Regiao AWS usada no laboratorio."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome base dos recursos."
  type        = string
  default     = "technova"
}

variable "environment" {
  description = "Ambiente da infraestrutura."
  type        = string
  default     = "development"
}

variable "owner_ra" {
  description = "RA do aluno."
  type        = string
  default     = "6325300"
}

variable "availability_zones" {
  description = "AZs usadas para EC2 e RDS."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  description = "CIDR da VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitido para SSH no EC2."
  type        = string
  default     = "0.0.0.0/0"
}

variable "ami_id_override" {
  description = "AMI opcional para contas sem permissao ec2:DescribeImages."
  type        = string
  default     = ""
}

variable "public_key_path" {
  description = "Caminho da chave publica para o Key Pair."
  type        = string
  default     = "~/.ssh/technova-key.pub"
}

variable "ssh_public_key" {
  description = "Chave publica SSH opcional. Substitui public_key_path se preenchida."
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_name" {
  description = "Nome do database PostgreSQL."
  type        = string
  default     = "technova"
}

variable "db_username" {
  description = "Usuario master do RDS."
  type        = string
  default     = "technova_admin"
}

variable "db_password" {
  description = "Senha master do RDS. Informe via terraform.tfvars ou TF_VAR_db_password."
  type        = string
  sensitive   = true
}

variable "use_lab_instance_profile" {
  description = "Use true no AWS Academy quando precisar usar LabInstanceProfile."
  type        = bool
  default     = true
}

variable "lab_instance_profile_name" {
  description = "Instance Profile pre-existente no AWS Academy Learner Lab."
  type        = string
  default     = "LabInstanceProfile"
}
