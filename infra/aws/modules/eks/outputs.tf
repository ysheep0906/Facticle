output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.cluster.name
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate" {
  description = "The certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "aws_iam_openid_connect_provider_arn" {
  description = "The ARN of the EKS OIDC provider"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "aws_iam_openid_connect_provider_url" {
  description = "The URL of the EKS OIDC provider"
  value       = aws_iam_openid_connect_provider.eks.url
}

output "node_group_security_group_id" {
  description = "The security group ID for the EKS node group"
  value       = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

