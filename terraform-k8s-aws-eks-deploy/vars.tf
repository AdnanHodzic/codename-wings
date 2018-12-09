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
