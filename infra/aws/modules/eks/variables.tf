variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "facticle"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "eks_iam_role_arn" {
  description = "The ARN of the EKS IAM Role"
  type        = string
}

variable "node_iam_role_arn" {
  description = "The ARN of the EKS Node IAM Role"
  type        = string
}