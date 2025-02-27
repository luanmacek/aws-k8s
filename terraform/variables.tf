# Variables
variable "project_name" {
  default = "myapp"
  description = "Name of the project"
}

variable "environment" {
  default = "dev"
  description = "Deployment environment"
}

variable "eks_cluster_name" {
  default = "my-eks-cluster"
  description = "Name of the EKS cluster"
}

variable "ecs_cluster_name" {
  default = "my-ecs-cluster"
  description = "Name of the ECS cluster"
}

variable "aws_region" {
  default = "eu-central-1"
  description = "AWS region for deployment"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "public_cidr" {
  default = "10.0.4.0/22"
  description = "CIDR block for public subnets"
}

variable "private_cidr" {
  default = "10.0.1.0/22"
  description = "CIDR block for private subnets"
}

variable "availability_zones" {
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  description = "List of availability zones"
}