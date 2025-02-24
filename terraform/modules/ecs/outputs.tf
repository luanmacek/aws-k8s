output "ecs_cluster_id" {
  description = "The ID of the ECS cluster."
  value       = aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  value       = aws_ecs_cluster.this.name
}

output "ecs_task_definition" {
  description = "ECS task definition ARN and revision"
  value       = "${aws_ecs_task_definition.this.family}:${aws_ecs_task_definition.this.revision}"
}