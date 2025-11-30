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
    subnet_ids = [var.private_subnets[0]]
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

# OpenSearch Security Group
resource "aws_security_group" "os_sg" {
  name   = "${var.project}-os-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow access from EKS nodes"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [
      var.node_group_security_group_id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}