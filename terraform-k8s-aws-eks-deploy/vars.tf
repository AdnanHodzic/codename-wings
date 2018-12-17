variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-13be557e"
    eu-central-1 = "ami-080d06f90eb293a27"
    eu-west-1 = "ami-02790d1ebf3b5181d"
  }
}

# values read from terraform.tfvars
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}

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
