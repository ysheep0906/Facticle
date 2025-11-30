# ALB Role
data "aws_iam_policy_document" "alb_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.aws_iam_openid_connect_provider_arn]
    }

    condition {
    test     = "StringEquals"
    variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:sub"
    values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "alb_role" {
  name               = "${var.project}-aws-lb-controller-role"
  assume_role_policy = data.aws_iam_policy_document.alb_assume_role.json
}

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

# S3 Role
data "aws_iam_policy_document" "s3_irsa_assume_role" { # IRSA를 위한 Assume Role Policy
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.aws_iam_openid_connect_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:default/s3-reader-sa" # ← 이 SA만 이 Role 쓸 수 있음
      ]
    }
  }
}

resource "aws_iam_role" "s3_reader_role" { # S3 읽기 전용 Role
  name               = "${var.project}-s3-reader"
  assume_role_policy = data.aws_iam_policy_document.s3_irsa_assume_role.json
}

data "aws_iam_policy_document" "s3_read_images" { # S3 읽기 전용 Policy
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_read_images" { # S3 읽기 전용 Policy 생성
  name   = "${var.project}-s3-read-images"
  policy = data.aws_iam_policy_document.s3_read_images.json
}

resource "aws_iam_role_policy_attachment" "attach_s3_read_images" { # S3 읽기 전용 Policy를 Role에 연결
  role       = aws_iam_role.s3_reader_role.name
  policy_arn = aws_iam_policy.s3_read_images.arn
}