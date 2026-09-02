variable "aws_region" {
  description = "Regiao AWS usada nos exercicios da disciplina."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto da TechNova."
  type        = string
  default     = "TechNova"
}

variable "environment" {
  description = "Ambiente usado para os recursos de aprendizado."
  type        = string
  default     = "development"
}

variable "aluno" {
  description = "Nome completo do aluno."
  type        = string
  default     = "Gabriel Carneiro da Silva"
}

variable "ra" {
  description = "Registro academico usado como prefixo para evitar conflito de nomes."
  type        = string
  default     = "6325300"
}

variable "disciplina" {
  description = "Nome da disciplina."
  type        = string
  default     = "DevOps - UniFAAT 2026-2"
}

variable "aula" {
  description = "Numero da aula."
  type        = string
  default     = "03"
}

locals {
  name_prefix = "${var.ra}-technova"

  common_tags = {
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Aluno       = var.aluno
    RA          = var.ra
    Disciplina  = var.disciplina
    Aula        = var.aula
    Environment = var.environment
  }
}
