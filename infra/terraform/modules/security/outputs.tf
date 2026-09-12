output "security_group_id" {
  description = "ID of the K3s Security Group"
  value       = aws_security_group.k3s.id
}