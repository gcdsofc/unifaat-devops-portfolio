variable "name" {
  description = "Nome do Security Group."
  type        = string
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "ID da VPC."
  type        = string
}

variable "project_name" {
  description = "Nome do projeto."
  type        = string
}

variable "environment" {
  description = "Nome do ambiente."
  type        = string
}

variable "ingress_rules" {
  description = "Lista de regras de entrada."
  type = list(object({
    description        = string
    from_port          = number
    to_port            = number
    protocol           = string
    cidr_blocks        = optional(list(string), [])
    security_group_ids = optional(list(string), [])
  }))
  default = []
}

variable "tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}
