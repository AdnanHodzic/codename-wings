resource "aws_instance" "prometheus" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "${var.ssh_key_name}"
  tags {
    Name = "prometheus"
  }

  provisioner "local-exec" {
     command = "echo ${aws_instance.prometheus.public_ip} > hosts"
  }
}

output "ip" {
    value = "${aws_instance.prometheus.public_ip}"
}
