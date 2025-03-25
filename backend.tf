terraform {
  backend "s3" {
    bucket         = "section-one-bucket"
    key            = "terraform/state/eks-cluster/vpc/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "section-one-table"
  }
}