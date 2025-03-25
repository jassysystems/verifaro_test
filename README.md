# verifaro_test

Section 1:

a. Create a Terraform conﬁguration to deploy an EKS cluster into AWS. This should be in a new VPC and include all other necessary resources. 
The new cluster should be designed to run up to 250 pods, handle a total peak memory usage of 28GB per node and be resilient to the failure of a single availability
zone. The administrator should be able to use AWS services to monitor metrics and view the logs of both the cluster and applications running in it. 


# How to run this on Dev Environment for e.g.

terraform init
terraform plan -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars