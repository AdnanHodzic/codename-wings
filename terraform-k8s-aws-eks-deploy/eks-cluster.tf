resource "aws_eks_cluster" "demo" {
  # cluster name defined in vars.tf
  name     = "${var.cluster-name}"
  # cluster needs a role define in iam.tf
  role_arn = "${aws_iam_role.demo-cluster.arn}"

  # specify in which security group this cluster needs to be launched (securitygroups.tf)
  vpc_config {
    security_group_ids = ["${aws_security_group.demo-cluster.id}"]
    # uses a module which returns public subnet ID's of this VPC
    subnet_ids         = ["${module.vpc.public_subnets}"]
  }

  /* Tells Terraform that this cluster can only be created after following
  policies have been attached (iam.tf) */
  depends_on = [
    "aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.demo-cluster-AmazonEKSServicePolicy",
  ]
}

