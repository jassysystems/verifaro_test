# verifaro_test

Section 1:

a. Create a Terraform conﬁguration to deploy an EKS cluster into AWS. This should be in a new VPC and include all other necessary resources. 
The new cluster should be designed to run up to 250 pods, handle a total peak memory usage of 28GB per node and be resilient to the failure of a single availability
zone. The administrator should be able to use AWS services to monitor metrics and view the logs of both the cluster and applications running in it. 

Backend Configuration (backend.tf)
This file configures the backend for storing the Terraform state remotely in an S3 bucket with DynamoDB for state locking.

Main Configuration (main.tf)
This is the main configuration that sets up the environment and uses the modules to deploy the EKS cluster.

Variable Definitions (variables.tf)
This file defines the variables used in the main configuration.

VPC Module (modules/vpc/main.tf)
This module creates a new VPC with public and private subnets across two availability zones.

IAM Module (modules/iam/main.tf)
This module creates the IAM roles for the EKS cluster and worker nodes.

EKS Module (modules/eks/main.tf)
This module creates the EKS cluster and worker nodes using the provided VPC and IAM roles.

Monitoring Module (modules/monitoring/main.tf)
This module sets up CloudWatch logs and enables the EKS cluster logging features.

Environment Configuration (environments/dev/terraform.tfvars)
This file sets environment-specific values for the dev environment.

# How to run this on Dev Environment for e.g.

terraform init
terraform plan -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars