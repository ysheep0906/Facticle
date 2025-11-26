resource "aws_db_instance" "mysql" {
  identifier               = "${var.project}-mysql"
  engine                   = "mysql"
  engine_version           = "8.0"
  instance_class           = "db.t3.micro"       # Free tier 가능
  allocated_storage        = 20
  max_allocated_storage    = 100
  db_subnet_group_name     = aws_db_subnet_group.rds_subnets.name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]

  publicly_accessible      = false
  skip_final_snapshot      = true

  username = var.db_username
  password = var.db_password

  tags = {
    Name = "${var.project}-mysql"
  }
}
