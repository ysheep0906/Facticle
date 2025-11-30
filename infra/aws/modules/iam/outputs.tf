output "eks_iam_role_arn" {
  description = "The ARN of the EKS IAM Role"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "node_iam_role_arn" {
  description = "The ARN of the EKS Node IAM Role"
  value       = aws_iam_role.node_role.arn
}