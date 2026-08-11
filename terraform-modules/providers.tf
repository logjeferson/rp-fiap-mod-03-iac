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

data "aws_eks_cluster" "my_cluster" {
  name = "eks-cluster-01"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.my_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.my_cluster.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.my_cluster.name]
      command     = "aws"
    }
  }
}