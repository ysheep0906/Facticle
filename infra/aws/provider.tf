provider "aws" {
    region = var.region
}

data "aws_eks_cluster" "eks" { # EKS 클러스터 정보 가져오기
  name = aws_eks_cluster.cluster.name
}

data "aws_eks_cluster_auth" "eks" { # EKS 클러스터 인증 정보 가져오기
  name = aws_eks_cluster.cluster.name
}

provider "kubernetes" { #
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data) 
  token                  = data.aws_eks_cluster_auth.eks.token 
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
