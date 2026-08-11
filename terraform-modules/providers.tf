terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "FIAP-MOD3"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = eks-cluster-01.endpoint
    cluster_ca_certificate = base64decode(eks-cluster-01.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", eks-cluster-01.name]
      command     = "aws"
    }
  }
}