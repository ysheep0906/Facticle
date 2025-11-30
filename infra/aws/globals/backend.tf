terraform {
  backend "s3" {
    bucket         = "facticle-terraform-state"    # S3 버킷 이름
    key            = "dev/terraform.tfstate"       # tfstate 파일 경로
    region         = "ap-northeast-2"
    dynamodb_table = "facticle-terraform-lock"     # 잠금 테이블
    encrypt        = true
  }
}