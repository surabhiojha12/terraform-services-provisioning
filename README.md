# Terraform - AWS Service Provisioning
The purpose of this repository is to use terraform to provision AWS resources.

## Setup
### Install Terraform
Official installation instructions from HashiCorp: https://learn.hashicorp.com/tutorials/terraform/install-cli

### AWS Account Setup
1. Create AWS account
2. create non-root AWS user
3. Add the necessary IAM policies (e.g. AmazonEC2FullAccess)
4. Save Access key + secret key (or use AWS CLI aws configure -- https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

## Sections
1. 01-sample-aws-services-provisioning
    - Terraform to provision aws resources with sample server to verify.
    - Follow README.md in the respective section.
