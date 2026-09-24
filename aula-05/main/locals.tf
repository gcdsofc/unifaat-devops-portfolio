locals {
  name_prefix = "${var.project_name}-aula05"

  common_tags = {
    Project     = "TechNova"
    Aula        = "05"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner_ra
  }

  public_subnet = {
    name     = "public-a"
    cidr     = "10.0.1.0/24"
    az_index = 0
  }

  private_subnets = {
    private_a = {
      name     = "private-a"
      cidr     = "10.0.2.0/24"
      az_index = 0
    }
    private_b = {
      name     = "private-b"
      cidr     = "10.0.3.0/24"
      az_index = 1
    }
  }

  ssh_public_key = trimspace(var.ssh_public_key) != "" ? trimspace(var.ssh_public_key) : trimspace(file(pathexpand(var.public_key_path)))

  amazon_linux_2023_ami_id = trimspace(var.ami_id_override) != "" ? trimspace(var.ami_id_override) : data.aws_ami.amazon_linux_2023[0].id
}
