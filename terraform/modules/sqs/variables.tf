variable "queue_name" {
  description = "Nome da fila SQS"
  type        = string
}

variable "eks_oidc_issuer_url" {
  description = "A URL do OIDC Provider gerada pelo EKS"
  type        = string
}

variable "eks_oidc_provider_arn" {
  description = "O ARN do IAM OIDC Provider do cluster EKS"
  type        = string
}