resource "aws_instance" "prometheus" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "${var.ssh_key_name}"
  tags {
    Name = "prometheus"
  }

  subnet_id = "${aws_subnet.prometheus-public-1.id}"
  vpc_security_group_ids = ["${aws_security_group.prometheus.id}"]

  provisioner "local-exec" {
     command = "echo ${aws_instance.prometheus.public_ip} > hosts"
  }
}

output "ip" {
    value = "${aws_instance.prometheus.public_ip}"
}
