provider "aws" {
  region  = "eu-west-1"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

provider "http" {}
