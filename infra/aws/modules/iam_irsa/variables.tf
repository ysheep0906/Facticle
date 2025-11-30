variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "facticle"
}

variable "aws_iam_openid_connect_provider_arn" {
  description = "The ARN of the EKS OIDC provider"
  type        = string
}

variable "aws_iam_openid_connect_provider_url" {
  description = "The URL of the EKS OIDC provider"
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

