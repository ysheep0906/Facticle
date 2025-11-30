data "aws_eks_cluster_auth" "eks" { # EKS 클러스터 인증 정보 가져오기
  name = module.eks.eks_cluster_name
}

provider "kubernetes" { 
  host                   = module.eks.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate)
  token                  = data.aws_eks_cluster_auth.eks.token 
}

provider "helm" {
  kubernetes {
    host                   = module.eks.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}


module "vpc" {
  source  = "../../modules/vpc"
  project = var.project
}

module "eks" {
  source             = "../../modules/eks"
  project            = var.project
  region             = var.region
  eks_iam_role_arn   = module.iam.eks_iam_role_arn
  public_subnets    = module.vpc.public_subnets
  private_subnets   = module.vpc.private_subnets
  node_iam_role_arn = module.iam.node_iam_role_arn
}

module "iam" {
  source  = "../../modules/iam"
  project = var.project
}

module "iam_irsa" {
  source  = "../../modules/iam_irsa"
  project = var.project
  aws_iam_openid_connect_provider_arn = module.eks.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_url = module.eks.aws_iam_openid_connect_provider_url
  s3_bucket_arn = module.s3.s3_bucket_arn
}

module "rds" {
  source     = "../../modules/rds"
  project    = var.project
  db_username = var.db_username
  db_password = var.db_password
  vpc_id    = module.vpc.vpc_id
  rds_subnet_group_name = module.vpc.rds_subnet_group_name
  node_group_security_group_id = module.eks.node_group_security_group_id
}

module "opensearch" {
  source     = "../../modules/opensearch"
  project    = var.project
  private_subnets   = module.vpc.private_subnets
  vpc_id    = module.vpc.vpc_id
  node_group_security_group_id = module.eks.node_group_security_group_id
}

module "alb_controller" {
  source     = "../../modules/alb-controller"
  project    = var.project
  alb_controller_iam_role_arn   = module.iam_irsa.alb_controller_iam_role_arn
  eks_cluster_name              = module.eks.eks_cluster_name
  vpc_id                       = module.vpc.vpc_id

  depends_on = [
    module.eks,
    module.iam,
  ]
}

module "ecr" {
  source  = "../../modules/ecr"
  project = var.project
}

module "s3" {
  source  = "../../modules/s3"
  project = var.project
}

