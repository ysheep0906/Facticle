output "rds_security_group_id" {
  description = "The ID of the RDS Security Group"
  value       = aws_security_group.rds_sg.id
}