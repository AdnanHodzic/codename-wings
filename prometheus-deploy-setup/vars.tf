variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-02790d1ebf3b5181d"
  }
}

variable "ssh_key_name" {
  default = "id_rsa_hodzic"
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "eu-west-1"
}
