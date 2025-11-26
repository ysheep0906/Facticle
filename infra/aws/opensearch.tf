resource "aws_opensearch_domain" "search" {
  domain_name = "${var.project}-search"

  engine_version = "OpenSearch_2.9"

  cluster_config {
    instance_type  = "t3.small.search"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 20
    volume_type = "gp3"
  }

  vpc_options {
    subnet_ids = [
      aws_subnet.private[0].id
    ]
    security_group_ids = [
      aws_security_group.os_sg.id
    ]
  }
     # 모든 사용자에게 전체 액세스 허용 (테스트 용도) - 나중에 제한 필요
  access_policies = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "*" },
      "Action": "es:*",
      "Resource": "*"
    }
  ]
}
EOF
}
