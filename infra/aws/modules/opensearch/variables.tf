variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "facticle"
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "node_group_security_group_id" {
  description = "The security group ID for the EKS node group"
  type        = string
}