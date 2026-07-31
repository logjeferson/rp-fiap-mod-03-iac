variable "region" {
  description = "Região da AWS para criar as sub-redes nas AZs corretas"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
  default     = "vpc-01"
}

variable "vpc_cidr" {
  description = "Bloco CIDR para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "igw_name" {
  description = "Nome da Internet Gateway"
  type        = string
  default     = "igw-01"
}

variable "subnet_publicA_name" {
  description = "Nome da Subnet PublicaA"
  type        = string
  default     = "snet-public-01"
}

variable "subnet_publicB_name" {
  description = "Nome da Subnet PublicaB"
  type        = string
  default     = "snet-public-02"
}

variable "subnet_privateA_name" {
  description = "Nome da Subnet PrivadaA"
  type        = string
  default     = "snet-private-01"
}

variable "subnet_privateB_name" {
  description = "Nome da Subnet PrivadaB"
  type        = string
  default     = "snet-private-02"
}

variable "nat_eip_name" {
  description = "Nome do Elastic IP para o NAT Gateway"
  type        = string
  default     = "eip-01"
}

variable "nat_gw_name" {
  description = "Nome do NAT Gateway"
  type        = string
  default     = "ngw-01"
}

variable "rt_public_name" {
  description = "Nome da Route Table Publica"
  type        = string
  default     = "rt-public-01"
}

variable "rt_private_name" {
  description = "Nome da Route Table Privada"
  type        = string
  default     = "rt-private-01"
}
