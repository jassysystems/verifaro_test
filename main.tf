provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  environment = var.environment
}

module "iam" {
  source = "./modules/iam"
  account_id = var.account_id
  cluster_name = var.cluster_name
}

module "eks" {
  source       = "./modules/eks"
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
  cluster_name = var.cluster_name
  node_size    = var.node_size
  node_count   = var.node_count
}

module "monitoring" {
  source       = "./modules/monitoring"
  cluster_name = var.cluster_name
}

module "ec2" {
  source = "./modules/ec2"
  ami = "ami-830c94e3"
  instance_type = "t2.micro"
}

module "s3" {
  source = "./modules/s3"
  bucket_prefix = "test-bucket"
}

resource "kubernetes_service_account" "order_processor_sa" {
  metadata {
    name      = "order-processor"
    namespace = var.namespace
  }
  automount_service_account_token = true
}