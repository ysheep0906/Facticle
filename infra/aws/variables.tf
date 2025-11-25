variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "facticle"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

# variable "db_username" {
#   type    = string
#   default = "admin"
# }

# variable "db_password" {
#   description = "RDS root password"
#   type        = string
#   sensitive   = true
# }
