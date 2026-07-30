variable "cache_cluster_name" {
  description = "O nome do cluster de cache ElastiCache"
  type        = string
}

variable "node_type" {
  description = "Tamanho das máquinas do ElastiCache"
  type        = string
  default     = "cache.t3.micro"
}

variable "subnet_ids" {
  description = "Lista de IDs das subnets privadas"
  type        = list(string)
}

variable "security_groups" {
  description = "Lista de IDs dos Security Groups"
  type        = list(string)
}