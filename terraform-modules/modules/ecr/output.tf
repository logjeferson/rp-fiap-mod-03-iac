output "repository_url" {
  description = "A URL do repositório ECR"
  value       = aws_ecr_repository.repo.repository_url
}