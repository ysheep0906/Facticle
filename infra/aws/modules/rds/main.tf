resource "aws_db_instance" "mysql" {
  identifier               = "${var.project}-mysql"
  engine                   = "mysql"
  engine_version           = "8.0"
  instance_class           = "db.t3.micro"       # Free tier 가능
  allocated_storage        = 20
  max_allocated_storage    = 100
  db_subnet_group_name     = var.rds_subnet_group_name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  publicly_accessible      = false
  skip_final_snapshot      = true

  username = var.db_username
  password = var.db_password

  tags = {
    Name = "${var.project}-mysql"
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name   = "${var.project}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "EKS NodeGroup access"
    from_port   = 3306
    to_port     = 3306
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

  tags = {
    Name = "${var.project}-rds-sg"
  }
}