output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnets" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

# vpc/main.tf
output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

# If you have a security group for ECS tasks, add its ID:
output "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  value       = aws_security_group.ecs_tasks.id  # Replace with your SG resource
}