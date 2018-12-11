variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-02790d1ebf3b5181d"
  }
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "cluster-name" {
  default = "terraform-k8s-eks-go-webapp"
  type    = "string"
}
variable "webapp-cluster-name" {
  default = "terraform-k8s-eks-webapp-cluster"
  type    = "string"
}
variable "webapp-node-name" {
  default = "terraform-k8s-eks-webapp-node"
  type    = "string"
}
variable "stack-name" {
  default = "terraform-k8s-eks-webapp"
  type    = "string"
}
