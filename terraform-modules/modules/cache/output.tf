output "cache_cluster_endpoint" {
  description = "A URL do nó do Redis"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}