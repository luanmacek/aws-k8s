# Fetch available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Module (using terraform-aws-modules/vpc/aws for correctness)
module "vpc_eks" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.18"
  
  name = "${var.project_name}-${var.environment}-vpc"
  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }

  # Explicitly ensure public subnets assign public IP addresses
  map_public_ip_on_launch = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "eks-cluster"
  cluster_version = "1.31"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    example = {
      instance_types = ["t3.micro"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }

  vpc_id     = module.vpc_eks.vpc_id
  subnet_ids = module.vpc_eks.public_subnets

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


module "ecs" {
  source          = "./modules/ecs"
  aws_region      = var.aws_region
  project_name    = "my-ecs-cluster"
  environment     = var.environment
  cluster_name    = var.ecs_cluster_name
  vpc_id          = module.vpc_eks.vpc_id
  subnet_ids      = module.vpc_eks.private_subnets
}

# Monitoring Module (placeholder, assuming it exists)
module "monitoring" {
  source       = "./modules/monitoring"
  aws_region   = var.aws_region
  project_name = var.project_name
  environment  = var.environment
  eks_cluster  = var.eks_cluster_name
  ecs_cluster  = var.ecs_cluster_name
}