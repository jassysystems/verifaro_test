variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "cluster_name" {
  type    = string
  default = "my-cluster"
}

variable "node_size" {
  type    = string
  default = "t3.medium"
}

variable "node_count" {
  type    = number
  default = 3
}