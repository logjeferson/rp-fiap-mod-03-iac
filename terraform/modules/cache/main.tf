# Subnet Group ElastiCache (Redis)
resource "aws_elasticache_subnet_group" "redis_subnet" {
  name       = "${var.cache_cluster_name}-subnet-group"
  subnet_ids = var.subnet_ids
}

# Cluster ElastiCache (Redis)
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.cache_cluster_name
  engine               = "redis"
  engine_version       = "7.1"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet.name
  security_group_ids   = var.security_groups
  tags = {
    Name = var.cache_cluster_name
  }
}