# verifaro_test

Section 1:

a. Add an OpsUser IAM role, granng it view only permissions to everything within the ops K8s namespace. 
The user arn:aws:iam::1234566789001:user/ops-alice will be using the role from the IP 52.94.236.248 

# Explanation

IAM Policy:

This policy grants view-only access to resources in the ops namespace in the EKS cluster. It allows actions such as Describe and List for resources like pods, services, deployments, replica sets, stateful sets, etc., but only in the ops namespace.

IAM Role:

The OpsUserRole role is created with a trust policy that allows the user ops-alice to assume the role only from the IP address 52.94.236.248. The trust relationship is enforced by the aws:SourceIp condition.

Policy Attachment:

The policy is attached to the OpsUserRole so that when ops-alice assumes the role, they will have the permissions defined in the policy (view-only permissions in the ops namespace).

# How to run this on Dev Environment for e.g.

terraform init
terraform plan -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars