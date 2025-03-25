resource "aws_cloudwatch_log_group" "eks_log_group" {
  name              = "eks-log-group-${var.cluster_name}"
  retention_in_days = 7
}

resource "aws_eks_cluster_logging" "eks_logging" {
  cluster_name = var.cluster_name
  enabled_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  depends_on = [aws_eks_cluster.main]
}