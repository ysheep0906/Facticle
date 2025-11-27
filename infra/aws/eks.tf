resource "aws_eks_cluster" "cluster" {
    name     = "${var.project}-eks"
    role_arn = aws_iam_role.eks_cluster_role.arn
    
    vpc_config { # EKS Cluster가 사용할 VPC 및 Subnet 설정
        subnet_ids = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
    }

    depends_on = [ # 
        aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.eks_cluster_AmazonEKSVPCResourceController
    ]

    tags = {
        Name = "${var.project}-eks"
    }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.project}-ng"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = aws_subnet.private[*].id # 노드 그룹은 Private Subnet에 생성

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
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
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

resource "null_resource" "wait_for_eks" { # EKS 클러스터와 노드 그룹이 준비될 때까지 대기
  depends_on = [ 
    aws_eks_cluster.cluster,
    aws_eks_node_group.node_group
  ]

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.cluster.name}

      until kubectl get nodes | grep -w "Ready"; do
        echo "Nodes not ready yet. Retrying in 10s..."
        sleep 10
      done

      kubectl wait --for=condition=Ready pods --all -n kube-system --timeout=300s
    EOT
  }
}
