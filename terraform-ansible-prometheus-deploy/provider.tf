/* keep aws keys secret by reading them from a file:
   - variables declared in: vars.tf
   - variable value read from: terraform.tfvars */
provider "aws" {
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
    region = "${var.AWS_REGION}"
}
