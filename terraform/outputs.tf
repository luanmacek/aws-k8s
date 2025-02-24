//////////////////////////////////////////////////////
// outputs.tf
//
// Exposes useful information from the root module.
//////////////////////////////////////////////////////

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.eks_cluster_id
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  value       = module.ecs.ecs_cluster_id
}
