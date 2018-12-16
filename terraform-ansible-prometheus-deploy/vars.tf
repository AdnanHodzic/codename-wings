variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-13be557e"
    eu-central-1 = "ami-080d06f90eb293a27"
    eu-west-1 = "ami-02790d1ebf3b5181d"
  }
}

variable "ssh_key_name" {
  default = "id_rsa_hodzic"
}

variable "p8s" {
  default = "prometheus"
}

# values read from terraform.tfvars
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}
