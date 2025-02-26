variable "aws_region" {
  type        = string
  description = "AWS region for ECS resources."
}

variable "cluster_name" {
  type        = string
  description = "Name for the ECS cluster."
}

variable "project_name" {
  type        = string
  description = "Project name used for tagging resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)."
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to all resources."
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC where ECS tasks will run"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where ECS tasks will run"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for ECS tasks"
  type        = list(string)
  default     = []
}
