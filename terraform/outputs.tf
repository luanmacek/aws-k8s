output "vpc_id" {
  value = module.vpc_eks.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc_eks.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc_eks.private_subnets
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_task_definition" {
  value = module.ecs.task_definition
}

output "ecs_security_group_id" {
  value = module.ecs.security_group_id
}
