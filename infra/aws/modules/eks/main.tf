resource "aws_eks_cluster" "cluster" {
    name     = "${var.project}-eks"
    role_arn = var.eks_iam_role_arn
    
    vpc_config { # EKS Cluster가 사용할 VPC 및 Subnet 설정
        subnet_ids = var.private_subnets
    }

    tags = {
        Name = "${var.project}-eks"
    }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.project}-ng"
  node_role_arn   = var.node_iam_role_arn
  subnet_ids      = var.private_subnets # 노드 그룹은 Private Subnet에 생성

  scaling_config { # 노드 그룹의 스케일링 설정
    desired_size = 3
    max_size     = 4
    min_size     = 2
  }

  instance_types = ["t3.medium"]

  tags = {
    Name = "${var.project}-ng"
  }

  depends_on = [
    aws_eks_cluster.cluster,
  ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = aws_eks_cluster.cluster.name
  addon_name        = "vpc-cni"
  resolve_conflicts_on_create  = "OVERWRITE"
  resolve_conflicts_on_update  = "OVERWRITE"
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.cluster.name
  addon_name        = "coredns"
  resolve_conflicts_on_create  = "OVERWRITE"
  resolve_conflicts_on_update  = "OVERWRITE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = aws_eks_cluster.cluster.name
  addon_name        = "kube-proxy"
  resolve_conflicts_on_create  = "OVERWRITE"
  resolve_conflicts_on_update  = "OVERWRITE"
}

# EKS OIDC Provider 참조
resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd10df6"] 
}
