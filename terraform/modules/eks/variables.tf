variable "cluster_name" {
  type        = string
  description = "Name for the EKS cluster."
}

variable "project_name" {
  type        = string
  description = "Project name used for tagging resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the EKS cluster."
}
