resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
  security_group_ids = [aws_security_group.eks_sg.id]

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy_attachment]
}

resource "aws_launch_configuration" "worker" {
  name_prefix          = "eks-worker-"
  image_id             = "ami-xxxxxxxx"  # Replace with a valid EKS-optimized AMI ID
  instance_type        = var.node_size
  security_groups      = [aws_security_group.eks_sg.id]
  iam_instance_profile = aws_iam_role.eks_worker_role.name
  user_data = <<-EOF
    #!/bin/bash
    /etc/eks/bootstrap.sh ${var.cluster_name}
  EOF
}

resource "aws_autoscaling_group" "worker_asg" {
  desired_capacity     = var.node_count
  max_size             = 5
  min_size             = var.node_count
  vpc_zone_identifier  = var.subnet_ids
  launch_configuration = aws_launch_configuration.worker.id
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"
  version      = "latest"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "kube-proxy"
  version      = "latest"
}