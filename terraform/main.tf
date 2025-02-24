module "vpc" {
  source             = "./modules/vpc"
  aws_region         = var.aws_region
  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.eks_cluster_name
  project_name = var.project_name
  environment  = var.environment
  subnet_ids   = module.vpc.private_subnets
}


module "ecs" {
  source       = "./modules/ecs"
  aws_region   = var.aws_region
  project_name = var.project_name
  environment  = var.environment
  cluster_name = var.ecs_cluster_name
}

module "monitoring" {
  source       = "./modules/monitoring"
  aws_region   = var.aws_region
  project_name = var.project_name
  environment  = var.environment
  eks_cluster  = module.eks.eks_cluster_name
  ecs_cluster  = module.ecs.ecs_cluster_name
}