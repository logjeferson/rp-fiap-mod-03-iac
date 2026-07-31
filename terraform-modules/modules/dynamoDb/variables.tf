variable "table_name" {
  description = "Nome da tabela do DynamoDB"
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

variable "sqs_shared_policy_arn" {
  description = "ARN da política do SQS que vem do módulo SQS"
  type        = string
}