output "cache_sg_id" {
  description = "Exporta o ID do Security Group do Cluster de Cache"
  value       = aws_security_group.cache_sg.id
}

output "rds_sg_id" {
  description = "Exporta o ID do Security Group do Banco de Dados"
  value       = aws_security_group.rds_sg.id
}
