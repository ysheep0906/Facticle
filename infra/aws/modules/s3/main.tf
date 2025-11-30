resource "aws_s3_bucket" "image_bucket" {
  bucket = "${var.project}-bucket"

  tags = {
    Name = "${var.project}-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "image_public_block" { 
  bucket = aws_s3_bucket.image_bucket.id

  block_public_acls   = true # S3 버킷에 대한 모든 퍼블릭 ACL 차단
  block_public_policy = true # 퍼블릭 정책 차단
  ignore_public_acls  = true # 퍼블릭 ACL 무시
  restrict_public_buckets = true # 퍼블릭 버킷 제한
}
