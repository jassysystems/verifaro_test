# import vpc module
module "webserver_cluster" {
  source = "../../modules/vpc"
  vpc_name = "vpc-webserver
}