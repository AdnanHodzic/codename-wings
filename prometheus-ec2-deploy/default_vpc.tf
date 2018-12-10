# default VPC
resource "aws_default_vpc" "default" {
    tags {
        Name = "Default VPC"
    }
}

# default subnets
resource "aws_default_subnet" "default_az1" {
  availability_zone = "${var.AWS_REGION}a"

    tags {
        Name = "Default subnet for ${var.AWS_REGION}a"
    }
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = "${var.AWS_REGION}b"

    tags {
        Name = "Default subnet for ${var.AWS_REGION}b"
    }
}
resource "aws_default_subnet" "default_az3" {
  availability_zone = "${var.AWS_REGION}c"

    tags {
        Name = "Default subnet for ${var.AWS_REGION}c"
    }
}
