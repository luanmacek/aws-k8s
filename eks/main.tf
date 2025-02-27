# Fetch available AZs (optional, if you prefer dynamic AZs)
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc_eks" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.18"  # Allows updates like 5.19.x if available

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
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "MyEKSClusterRole"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "sts:AssumeRole",
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })

  tags = {
    Name = "MyEKSClusterRole"
  }
}

# IAM Role for Worker Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "${var.project_name}-${var.environment}-eks-node-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "sts:AssumeRole",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-eks-node-role"
  }
}

# IAM Role for Fargate Pods
resource "aws_iam_role" "eks_fargate_pod_role" {
  name = "MyEKSFargatePodRole"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "sts:AssumeRole",
      Principal = { Service = "eks-fargate-pods.amazonaws.com" }
    }]
  })

  tags = {
    Name = "MyEKSFargatePodRole"
  }
}

# IAM Policy Attachments for Worker Nodes
resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

###############################
# EKS Cluster
###############################

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids             = concat(module.vpc_eks.public_subnets, module.vpc_eks.private_subnets)
    endpoint_public_access = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  tags = {
    Name        = "${var.project_name}-${var.environment}-eks-cluster"
    Environment = var.environment
    Project     = var.project_name
  }
}

###############################
# Node Group
###############################

resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-${var.environment}-public-ng"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = module.vpc_eks.public_subnets

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.small"]

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-ng"
    Environment = var.environment
  }
}

###############################
# Fargate Profile
###############################

resource "aws_eks_fargate_profile" "default" {
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "${var.project_name}-${var.environment}-fargate"
  pod_execution_role_arn = aws_iam_role.eks_fargate_pod_role.arn
  subnet_ids             = module.vpc_eks.private_subnets

  selector {
    namespace = "default"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-fargate-profile"
    Environment = var.environment
    Project     = var.project_name
  }
}

###############################
# Security Group
###############################

resource "aws_security_group" "eks_nodes" {
  name        = "${var.project_name}-${var.environment}-eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = module.vpc_eks.vpc_id

  ingress {
    description     = "Allow cluster to communicate with nodes (kubelet)"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-eks-node-sg"
  }
}

resource "aws_security_group_rule" "cluster_ingress_nodes" {
  description              = "Allow nodes to communicate with EKS API"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.eks_nodes.id
}