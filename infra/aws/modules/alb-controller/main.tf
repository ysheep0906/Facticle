# ServiceAccount 생성
resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = var.alb_controller_iam_role_arn
    }
  }
}

# Helm으로 AWS Load Balancer Controller 설치
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set { # 필수 값 설정
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set { # 기존에 생성한 ServiceAccount 사용
    name  = "serviceAccount.create"
    value = "false"
  }

  set { # ServiceAccount 이름 지정
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set { # 리전 설정
    name  = "region"
    value = var.region
  }

  set { # VPC ID 설정
    name  = "vpcId"
    value = var.vpc_id
  }
}
