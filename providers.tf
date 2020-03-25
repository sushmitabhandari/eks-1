#
# Provider Configuration
#

provider "aws" {
  region  = "ap-south-1"
  assume_role {
    role_arn     = "arn:aws:iam::686522566015:role/eks-ec2-role"
}
  }

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

# Not required: currently used in conjuction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {}
