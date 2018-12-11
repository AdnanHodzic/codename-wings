resource "aws_security_group" "prometheus" {
  vpc_id = "${aws_vpc.prometheus.id}"
  name = "${var.p8s}"
  description = "security group for Prometheus server"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-all-outbound"
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-http"
  }

  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-https"
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-ssh"
  }

  ingress {
      from_port = 9090
      to_port = 9090
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "prometheus-server"
  }

  ingress {
      from_port = 9100
      to_port = 9100
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "${var.p8s}"
  }

}
