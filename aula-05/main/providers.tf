terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "technova-tfstate-6325300-aula05"
    key            = "aula-05/main/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "technova-terraform-locks-6325300-aula05"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
