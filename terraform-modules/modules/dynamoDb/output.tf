output "table_name" {
  description = "O nome da tabela do DynamoDB"
  value       = aws_dynamodb_table.table.name
}

output "table_arn" {
  description = "O ARN da tabela do DynamoDB"
  value       = aws_dynamodb_table.table.arn
}

output "analytics_role_arn" {
  description = "ARN da Role do IAM para o Service Account do Analytics"
  value       = aws_iam_role.analytics_role.arn
}

output "shared_dynamo_policy_arn" {
  description = "ARN da Política do IAM para o DynamoDB"
  value       = aws_iam_policy.dynamodb_shared_policy.arn
}