output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "rds_subnet_group_name" {
  description = "The name of the RDS Subnet Group"
  value       = aws_db_subnet_group.rds_subnets.name
}



