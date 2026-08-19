# Security Group ElastiCache (Redis)
resource "aws_security_group" "cache_sg" {
  name        = var.nsg_cache_name
  description = "Permite acesso ao Cache em toda a VPC"
  vpc_id      = var.vpc_id
  tags        = { Name = var.nsg_cache_name }
  ingress {
    description = "Acesso interno ao Redis (VPC)"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

# Security Group Relational Database Service (RDS)
resource "aws_security_group" "rds_sg" {
  name        = var.nsg_rds_name
  description = "Permite acesso ao RDS em toda a VPC"
  vpc_id      = var.vpc_id
  tags        = { Name = var.nsg_rds_name }

  ingress {
    description = "Acesso interno ao PostgreSQL (VPC)"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}
