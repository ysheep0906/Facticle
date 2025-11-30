variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "facticle"
}

variable "db_username" {
  type    = string
  default = "facticle_user"
}

variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "rds_subnet_group_name" {
  description = "The name of the RDS Subnet Group"
  type        = string
}

variable "node_group_security_group_id" {
  description = "The security group ID for the EKS node group"
  type        = string
}