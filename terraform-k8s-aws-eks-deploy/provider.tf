provider "aws" {
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
    region = "${var.AWS_REGION}"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

provider "http" {}
