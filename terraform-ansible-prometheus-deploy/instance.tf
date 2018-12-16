resource "aws_instance" "prometheus" {
  # find AMI (values) based on region (key) from vars.tf
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  # read value from vars.tf
  key_name = "${var.ssh_key_name}"
  tags {
    Name = "prometheus"
  }

  # VPC subnet (eu-west-1)
  subnet_id = "${aws_subnet.prometheus-public-1.id}"
  # Security Group (Prometheus Server)
  vpc_security_group_ids = ["${aws_security_group.prometheus.id}"]

  # locally output aws_instance public IP to hosts file
  provisioner "local-exec" {
     command = "echo ${aws_instance.prometheus.public_ip} > hosts"
  }
}

# locally output aws_instance public ip to stdout
output "ip" {
    value = "${aws_instance.prometheus.public_ip}"
}
