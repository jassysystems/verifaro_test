output "eks_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}
output "worker_role_arn" {
  value = aws_iam_role.eks_worker_role.arn
}