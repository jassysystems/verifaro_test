resource "aws_iam_policy" "ops_user_view_only_policy" {
  name        = "OpsUserViewOnlyPolicy"
  description = "Grants view-only permissions to everything within the ops Kubernetes namespace"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:DescribeNodegroup",
          "eks:ListUpdates",
          "eks:DescribeUpdate",
          "eks:ListClusters",
          "eks:ListNodegroups",
          "eks:ListFargateProfiles",
          "eks:DescribeFargateProfile"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = "eks:DescribeNamespace"
        Effect   = "Allow"
        Resource = "arn:aws:eks:${var.aws_region}:${var.account_id}:cluster/${var.cluster_name}/namespace/ops"
      },
      {
        Action = [
          "eks:ListPods",
          "eks:DescribePod",
          "eks:ListServices",
          "eks:DescribeService",
          "eks:ListDeployments",
          "eks:DescribeDeployment",
          "eks:ListReplicaSets",
          "eks:DescribeReplicaSet",
          "eks:ListStatefulSets",
          "eks:DescribeStatefulSet"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:eks:${var.aws_region}:${var.account_id}:cluster/${var.cluster_name}/namespace/ops/*"
      }
    ]
  })
}

resource "aws_iam_policy" "order_processor_s3_policy" {
  name        = "OrderProcessorS3Policy"
  description = "Grants permission to read objects from the incoming-orders S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:ListBucket"
        Effect = "Allow"
        Resource = "arn:aws:s3:::incoming-orders"  # S3 bucket ARN
      },
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Resource = "arn:aws:s3:::incoming-orders/*"  # S3 objects within the bucket
      }
    ]
  })
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "eks_worker_role" {
  name = "eks-worker-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "ops_user_role" {
  name               = "OpsUserRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::1234566789001:user/ops-alice"
        }
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "52.94.236.248"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "order_processor_role" {
  name = "order-processor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRoleWithWebIdentity"
        Effect    = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${module.eks.cluster_oidc_issuer}"
        }
        Condition = {
          StringEquals = {
            "oidc.eks.${var.aws_region}.amazonaws.com/id/${module.eks.cluster_oidc_issuer}:sub" = "system:serviceaccount:${var.namespace}:order-processor"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "attach_view_only_policy" {
  policy_arn = aws_iam_policy.ops_user_view_only_policy.arn
  role       = aws_iam_role.ops_user_role.name
}

resource "aws_iam_role_policy_attachment" "order_processor_role_policy_attachment" {
  policy_arn = aws_iam_policy.order_processor_s3_policy.arn
  role       = aws_iam_role.order_processor_role.name
}