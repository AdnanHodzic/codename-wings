/* keep aws keys secret by reading them from a file:
   - variables declared in: vars.tf
   - variable value read from: terraform.tfvars */
provider "aws" {
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
    /* must be eu-west-1 as EKS is currently
    only available in this European region */
    region = "${var.AWS_REGION}"
}

/* Use Data Source to obtain the name of the AWS
region configured on the provider (vpc.tf) */
data "aws_region" "current" {}

# Use Data Source for AZ's (vpc.tf)
data "aws_availability_zones" "available" {}

/* HTTP provider to be able to query HTTP to get
external IP address for workstation (external-ip.tf) */
provider "http" {}
