locals {
  name_prefix = var.project_name

  common_tags = {
    Project     = "TechNova"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner_ra
  }

  public_subnets = {
    public_a = {
      name     = "public-a"
      cidr     = "10.0.1.0/24"
      az_index = 0
    }
    public_b = {
      name     = "public-b"
      cidr     = "10.0.3.0/24"
      az_index = 1
    }
  }

  private_subnets = {
    private_a = {
      name     = "private-a"
      cidr     = "10.0.2.0/24"
      az_index = 0
    }
    private_b = {
      name     = "private-b"
      cidr     = "10.0.4.0/24"
      az_index = 1
    }
  }

  ssh_public_key = trimspace(var.ssh_public_key) != "" ? trimspace(var.ssh_public_key) : trimspace(file(pathexpand(var.public_key_path)))

  amazon_linux_2023_ami_id = trimspace(var.ami_id_override) != "" ? trimspace(var.ami_id_override) : data.aws_ami.amazon_linux_2023[0].id

  ec2_instance_profile_name = var.use_lab_instance_profile ? var.lab_instance_profile_name : aws_iam_instance_profile.ec2[0].name
}
