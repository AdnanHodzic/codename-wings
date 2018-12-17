module "vpc" {
  /* uses VPC module to create VPC in region of our choice
  reference: https://github.com/terraform-aws-modules/terraform-aws-vpc#usage */
  source = "terraform-aws-modules/vpc/aws"

  # VPC name and CIDR block
  name = "vpc-module-demo"
  cidr = "10.0.0.0/16"

  # list Availability Zones using Data Source and use one of 3 available zones of selected region
  azs             = ["${slice(data.aws_availability_zones.available.names, 0, 3)}"]
  # private subnet ranges
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  # public subnet ranges
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # don't provision NAT Gateways for each of your private networks
  enable_nat_gateway = false
  # don't create a new VPN Gateway resource and attach it to the VPC
  enable_vpn_gateway = false

  # AWS tagging
  tags = "${
    map(
     "Name", "${var.stack-name}",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

