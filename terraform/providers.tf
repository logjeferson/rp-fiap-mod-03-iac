terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn     = "arn:aws:iam::162521700965:role/azure-devops-role"
    session_name = "azure-devops-role"
    duration     = "1h"
  }

  default_tags {
    tags = {
      Project = "FIAP-MOD3"
    }
  }
}
