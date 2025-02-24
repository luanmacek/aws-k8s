output "eks_dashboard_name" {
  description = "The name of the EKS CloudWatch dashboard."
  value       = aws_cloudwatch_dashboard.eks_dashboard.dashboard_name
}

output "ecs_dashboard_name" {
  description = "The name of the ECS CloudWatch dashboard."
  value       = aws_cloudwatch_dashboard.ecs_dashboard.dashboard_name
}
