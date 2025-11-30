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

variable "alb_controller_iam_role_arn" {
  description = "The ARN of the ALB Controller IAM Role"
  type        = string
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}