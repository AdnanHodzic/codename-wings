# Use Data Source to go to this URL and return IP of host we're running this on
data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

# so we can add that IP to Security Group establish seamless connection with cluster
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}
