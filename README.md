# verifaro_test

Section 1:

a. Add components so that pods using the order-processor K8s service account get credenals injected granng them permissions to enumerate and read objects 
from the incoming-orders S3 bucket.

# Explanation

To allow pods using the order-processor Kubernetes service account to get credentials injected for accessing the incoming-orders S3 bucket, we need to use IAM roles for service accounts (IRSA) in Amazon EKS. This allows Kubernetes workloads (pods) to assume IAM roles and use those credentials to access AWS resources securely.

The process involves the following steps:

Create an IAM policy granting permissions to read objects from the incoming-orders S3 bucket.

Create an IAM role that can be assumed by the Kubernetes service account (order-processor).

Associate the IAM role with the Kubernetes service account using the OIDC identity provider.

Deploy the Kubernetes Service Account and ensure that pods using this service account can use the IAM role to access the S3 bucket.


# How to run this on Dev Environment for e.g.

terraform init
terraform plan -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars