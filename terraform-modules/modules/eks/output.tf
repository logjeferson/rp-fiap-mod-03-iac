output "cluster_name" {
  description = "Nome do cluster provisionado"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "URL de comunicação da API do Kubernetes"
  value       = aws_eks_cluster.main.endpoint
}

output "oidc_issuer_url" {
  description = "URL do OIDC Provider gerada pelo cluster EKS"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  description = "ARN do IAM OIDC Provider"
  value       = aws_iam_openid_connect_provider.eks.arn
}