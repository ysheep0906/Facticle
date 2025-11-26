# EKS OIDC Provider 참조
resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd10df6"] # 
}

# AssumeRole 정책
data "aws_iam_policy_document" "alb_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
    test     = "StringEquals"
    variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
    values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
  }
  }
}

# ALB Controller용 IAM Role 생성
resource "aws_iam_role" "alb_role" {
  name               = "${var.project}-aws-lb-controller-role"
  assume_role_policy = data.aws_iam_policy_document.alb_assume_role.json
}

# ALB Controller용 IAM Role에 정책 연결
data "aws_iam_policy_document" "alb_controller_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:AuthorizeSecurityGroupIngress",
      "elasticloadbalancing:*",
      "iam:CreateServiceLinkedRole",
      "iam:GetServerCertificate",
      "iam:ListServerCertificates"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "alb_controller_policy" {
  name   = "${var.project}-alb-controller-policy"
  policy = data.aws_iam_policy_document.alb_controller_policy.json
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.alb_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}


# ServiceAccount 생성
resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_role.arn
    }
  }
}

# Helm으로 AWS Load Balancer Controller 설치
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  depends_on = [
    kubernetes_service_account.alb_sa,
    aws_eks_addon.vpc_cni,
    aws_eks_addon.coredns,
    aws_eks_addon.kube_proxy
  ]

  set { # 필수 값 설정
    name  = "clusterName"
    value = aws_eks_cluster.cluster.name
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
}
