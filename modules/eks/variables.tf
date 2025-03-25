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

variable "subnet_ids" {
  type    = list(string)
}