output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "ecs_security_group_id" {
  value = module.vpc.ecs_security_group_id
}

output "ecs_cluster_name" {
  value = module.ecs.ecs_cluster_name
}

output "ecs_task_definition" {
  value = module.ecs.ecs_task_definition
}