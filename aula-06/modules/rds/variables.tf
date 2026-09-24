variable "db_name" {
  description = "Nome do database."
  type        = string
}

variable "db_username" {
  description = "Usuario master do RDS."
  type        = string
}

variable "db_password" {
  description = "Senha master do RDS."
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "Subnets privadas para DB Subnet Group."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Groups associados ao RDS."
  type        = list(string)
}

variable "instance_class" {
  description = "Classe da instancia RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Armazenamento alocado em GB."
  type        = number
  default     = 20
}

variable "environment" {
  description = "Nome do ambiente."
  type        = string
}

variable "project_name" {
  description = "Nome do projeto."
  type        = string
}

variable "tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}
