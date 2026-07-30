# output "cluster_eks_command" {
#   description = "Comando para configurar o kubectl no seu computador"
#   value       = "aws eks update-kubeconfig --region us-east-1 --name ${module.eks_cluster.cluster_name}"
# }

output "ecr_repos" {
  description = "URLs de todos os repositórios ECR gerados"
  value = {
    for chave, repo in module.ecr_repos : chave => repo.repository_url
  }
}

# output "cluster_cache_endpoint" {
#   description = "Endpoint de conexão do ElastiCache Redis"
#   value       = module.cache_cluster.cache_cluster_endpoint
# }

# output "sqs_queue_url" {
#   description = "URL da fila SQS gerada"
#   value       = module.sqs_queue.queue_url
# }

# output "dynamodb_table_name" {
#   description = "Nome da tabela do DynamoDB"
#   value       = module.dynamodb_tables.table_name
# }

# output "rds_endpoints" {
#   description = "Endpoints de todos os bancos de dados gerados no loop"
#   value = {
#     for chave, banco in module.rds_databases : chave => banco.rds_endpoint
#   }
# }

# output "evaluation_role_arn" {
#   description = "ARN da Role do IAM para o Service Account do Evaluation"
#   value       = module.sqs_queue.evaluation_role_arn
# }

# output "keda_sqs_role_arn" {
#   description = "ARN da Role do IAM para o Service Account do KEDA"
#   value       = module.sqs_queue.keda_sqs_role_arn
# }

# output "analytics_role_arn" {
#   description = "ARN da Role do IAM para o Service Account do Analytics"
#   value       = module.dynamodb_tables.analytics_role_arn
# }

# output "shared_sqs_policy_arn" {
#   description = "ARN da Política do IAM para o SQS"
#   value       = module.sqs_queue.shared_sqs_policy_arn
# }

# output "shared_dynamo_policy_arn" {
#   description = "ARN da Política do IAM para o DynamoDB"
#   value       = module.dynamodb_tables.shared_dynamo_policy_arn
# }