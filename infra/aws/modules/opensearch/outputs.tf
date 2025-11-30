output "os_security_group_id" {
  description = "The ID of the OpenSearch Security Group"
  value       = aws_security_group.os_sg.id
}