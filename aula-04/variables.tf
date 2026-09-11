variable "aws_region" {
  description = "Regiao AWS usada no laboratorio."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome base usado nos recursos da TechNova."
  type        = string
  default     = "technova"
}

variable "environment" {
  description = "Ambiente dos recursos."
  type        = string
  default     = "development"
}

variable "owner_ra" {
  description = "RA do aluno responsavel pela infraestrutura."
  type        = string
  default     = "6325300"
}

variable "vpc_cidr" {
  description = "Bloco CIDR principal da VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Duas AZs usadas para distribuir as subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "Informe pelo menos duas Availability Zones."
  }
}

variable "ami_id_override" {
  description = "AMI opcional para contas sem permissao ec2:DescribeImages. Se vazio, usa data source do Amazon Linux 2023."
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitido para SSH. O TF pede 0.0.0.0/0, mas em producao deve ser restrito."
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_key_path" {
  description = "Caminho da chave publica usada para criar o Key Pair na AWS."
  type        = string
  default     = "~/.ssh/technova-key.pub"
}

variable "ssh_public_key" {
  description = "Chave publica SSH opcional. Se preenchida, substitui public_key_path."
  type        = string
  default     = ""
  sensitive   = true
}

variable "use_lab_instance_profile" {
  description = "Use true no AWS Academy Learner Lab quando a criacao de IAM Role estiver bloqueada."
  type        = bool
  default     = false
}

variable "lab_instance_profile_name" {
  description = "Instance Profile pre-existente do AWS Academy Learner Lab."
  type        = string
  default     = "LabInstanceProfile"
}
