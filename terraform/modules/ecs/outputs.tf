output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "task_definition" {
  value = aws_ecs_task_definition.this.family
}

output "security_group_id" {
  value = aws_security_group.ecs_tasks.id
}
