variable "instance_name" {
  description = "Nome da instancia EC2."
  type        = string
}

variable "instance_type" {
  description = "Tipo da instancia."
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID usada na instancia."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID onde a EC2 sera criada."
  type        = string
}

variable "security_group_ids" {
  description = "Security Groups associados a EC2."
  type        = list(string)
}

variable "key_name" {
  description = "Nome do Key Pair."
  type        = string
}

variable "user_data" {
  description = "User data opcional."
  type        = string
  default     = null
}

variable "project_name" {
  description = "Nome do projeto."
  type        = string
}

variable "environment" {
  description = "Nome do ambiente."
  type        = string
}

variable "tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}
