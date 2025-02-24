resource "aws_cloudwatch_dashboard" "eks_dashboard" {
  dashboard_name = "${var.project_name}-${var.environment}-eks-dashboard"
  dashboard_body = templatefile("${path.module}/templates/eks_dashboard.json", {
    eks_cluster = var.eks_cluster
  })
}

resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "${var.project_name}-${var.environment}-ecs-dashboard"
  dashboard_body = templatefile("${path.module}/templates/ecs_dashboard.json", {
    ecs_cluster = var.ecs_cluster
  })
}
