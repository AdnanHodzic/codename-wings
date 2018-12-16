resource "aws_security_group" "prometheus" {
  # tied to Prometheus VPC
  vpc_id = "${aws_vpc.prometheus.id}"
  name = "${var.p8s}"
  description = "security group for Prometheus server"
  # allow all outbound traffic on all ports
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-all-outbound"
  }

  # allow inbound traffic on port 80 (HTTP)
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-http"
  }

  # allow inbound traffic on port 443 (HTTPS)
  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-https"
  }

  # allow all inbound traffic on port 22 (SSH)
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-ssh"
  }

  # allow all inbound traffic on port 9090 (Prometheus)
  ingress {
      from_port = 9090
      to_port = 9090
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "prometheus-server"
  }

  # allow all inbound traffic on port 9100 (Node exported localhost)
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
