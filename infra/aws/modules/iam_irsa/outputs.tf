output "alb_controller_iam_role_arn" {
  description = "The ARN of the ALB Controller IAM Role"
  value       = aws_iam_role.alb_role.arn
}

output "s3_reader_role_arn" {
  description = "The ARN of the S3 Reader IAM Role"
  value       = aws_iam_role.s3_reader_role.arn
}