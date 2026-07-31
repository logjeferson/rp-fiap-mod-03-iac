variable "rds_name" {
  description = "Nome do RDS"
  type        = string
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
}

variable "db_user" {
  description = "Usuário master do banco de dados"
  type        = string
}

variable "db_pass" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "Tamanho das máquinas do RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "subnet_ids" {
  description = "Lista de IDs das sub-redes privadas para o DB Subnet Group"
  type        = list(string)
}

variable "security_groups" {
  description = "Lista de IDs de Security Groups para anexar ao RDS"
  type        = list(string)
}
