resource "aws_ecr_repository" "backend" {
    name = "${var.project}-backend"

    image_scanning_configuration { # 이미지 푸시 시 자동 스캔 활성화
        scan_on_push = true
    }
    
    tags = {
        Name = "${var.project}-backend"
    }
}

resource "aws_ecr_repository" "frontend" {
    name = "${var.project}-frontend"

    image_scanning_configuration { # 이미지 푸시 시 자동 스캔 활성화
        scan_on_push = true
    }
    
    tags = {
        Name = "${var.project}-frontend"
    }
}

resource "aws_ecr_repository" "crawler" {
    name = "${var.project}-crawler"

    image_scanning_configuration { # 이미지 푸시 시 자동 스캔 활성화
        scan_on_push = true
    }
    
    tags = {
        Name = "${var.project}-crawler"
    }
}
