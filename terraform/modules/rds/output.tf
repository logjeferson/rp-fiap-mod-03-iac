output "rds_endpoint" {
  description = "URL de conexão do banco de dados"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_port" {
  description = "A porta em que o banco está rodando"
  value       = aws_db_instance.postgres.port
}
