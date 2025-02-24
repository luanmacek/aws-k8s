variable "aws_region" {
  type        = string
  description = "AWS region for monitoring resources."
}

variable "project_name" {
  type        = string
  description = "Project name used for tagging resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)."
}

variable "eks_cluster" {
  type        = string
  description = "EKS cluster name."
}

variable "ecs_cluster" {
  type        = string
  description = "ECS cluster name."
}
