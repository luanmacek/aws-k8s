variable "cluster_name" {
  description = "Name of the EKS cluster"
}

variable "project_name" {
  description = "Name of the project"
}

variable "environment" {
  description = "Deployment environment"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the node group"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the Fargate profile"
  type        = list(string)
}