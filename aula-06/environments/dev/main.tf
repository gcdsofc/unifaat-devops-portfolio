locals {
  common_tags = {
    Aula  = "06"
    Owner = var.owner_ra
  }

  subnets = {
    public-1  = { cidr = "10.0.1.0/24", az = "us-east-1a", type = "public" }
    public-2  = { cidr = "10.0.2.0/24", az = "us-east-1b", type = "public" }
    private-1 = { cidr = "10.0.3.0/24", az = "us-east-1a", type = "private" }
    private-2 = { cidr = "10.0.4.0/24", az = "us-east-1b", type = "private" }
  }
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr     = "10.0.0.0/16"
  project_name = var.project_name
  environment  = var.environment
  subnets      = local.subnets
  tags         = local.common_tags
}

module "api_sg" {
  source = "../../modules/security-group"

  name         = "${var.project_name}-${var.environment}-api-sg"
  description  = "Security Group da API ${var.environment}"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags

  ingress_rules = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "API Node.js"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "rds_sg" {
  source = "../../modules/security-group"

  name         = "${var.project_name}-${var.environment}-rds-sg"
  description  = "Security Group do RDS ${var.environment}"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags

  ingress_rules = [
    {
      description        = "PostgreSQL from API SG"
      from_port          = 5432
      to_port            = 5432
      protocol           = "tcp"
      security_group_ids = [module.api_sg.sg_id]
    }
  ]
}

module "api_server" {
  source = "../../modules/ec2"

  instance_name      = "${var.project_name}-${var.environment}-api"
  instance_type      = "t2.micro"
  ami_id             = var.ami_id
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.api_sg.sg_id]
  key_name           = var.key_name
  user_data          = "#!/bin/bash\ndnf install -y postgresql15\n"
  project_name       = var.project_name
  environment        = var.environment
  tags               = local.common_tags
}

module "database" {
  source = "../../modules/rds"

  db_name            = "technova_dev"
  db_username        = "technova_admin"
  db_password        = var.db_password
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.rds_sg.sg_id]
  instance_class     = "db.t3.micro"
  project_name       = var.project_name
  environment        = var.environment
  tags               = local.common_tags
}
