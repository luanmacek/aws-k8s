# Create the IAM Role for the EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "MyEKSClusterRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "MyEKSClusterRole"
  }
}

# Create the IAM Role for Fargate Pod Execution
resource "aws_iam_role" "eks_fargate_pod_role" {
  name = "MyEKSFargatePodRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "MyEKSFargatePodRole"
  }
}

# Create the EKS Cluster using the created IAM role
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-eks-cluster"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create the Fargate Profile for the EKS Cluster
resource "aws_eks_fargate_profile" "default" {
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "${var.project_name}-${var.environment}-fargate"
  pod_execution_role_arn = aws_iam_role.eks_fargate_pod_role.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = "default"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-fargate-profile"
    Environment = var.environment
    Project     = var.project_name
  }
}
