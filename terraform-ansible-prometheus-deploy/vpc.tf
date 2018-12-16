/* Internet VPC
run instances on shared/multi tenant hardware
and assign internal hostname/domain names
disable link from VPC to EC2 classic */
resource "aws_vpc" "prometheus" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "${var.p8s}"
    }
}

/* Public Subnet (eu-west-1)
each public subnet refers to Internet VPC
and gives every instance public IP on launch
to connect to the Internet */
resource "aws_subnet" "prometheus-public-1" {
    vpc_id = "${aws_vpc.prometheus.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1a"

    tags {
        Name = "${var.p8s}-public-1"
    }
}
# Public subnet (eu-west-2)
resource "aws_subnet" "prometheus-public-2" {
    vpc_id = "${aws_vpc.prometheus.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1b"

    tags {
        Name = "${var.p8s}-public-2"
    }
}
# Public sunet (eu-west-1c)
resource "aws_subnet" "prometheus-public-3" {
    vpc_id = "${aws_vpc.prometheus.id}"
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1c"

    tags {
        Name = "${var.p8s}-public-3"
    }
}
/* Private subnet (eu-west-1a)
in case instance is launched in one of private subnets
(unlike Public subnets) public IP will not be added on launch */
resource "aws_subnet" "prometheus-private-1" {
    vpc_id = "${aws_vpc.prometheus.id}"
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-west-1a"

    tags {
        Name = "${var.p8s}-private-1"
    }
}
# Private subnet (eu-west-1b)
resource "aws_subnet" "prometheus-private-2" {
    vpc_id = "${aws_vpc.prometheus.id}"
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-west-1b"

    tags {
        Name = "${var.p8s}-private-2"
    }
}
# Private subnet (eu-west-1c)
resource "aws_subnet" "prometheus-private-3" {
    vpc_id = "${aws_vpc.prometheus.id}"
    cidr_block = "10.0.6.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-west-1c"

    tags {
        Name = "${var.p8s}-private-3"
    }
}

/* Internet Gateway
needed for Public subnets to be connected to the internet
this resource creates that gateway for this VPC */
resource "aws_internet_gateway" "prometheus-gw" {
    vpc_id = "${aws_vpc.prometheus.id}"

    tags {
        Name = "${var.p8s}"
    }
}

/* Route table
will route all traffic that's not internal (doesn't match VPC range) via
Internet Gateway. This route will only be pushed to instances if association
with Public Subnets exist (see below). */
resource "aws_route_table" "prometheus-public" {
    vpc_id = "${aws_vpc.prometheus.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.prometheus-gw.id}"
    }

    tags {
        Name = "${var.p8s}-public-1"
    }
}

# Associate Route table with Public subnet (1a)
resource "aws_route_table_association" "prometheus-public-1-a" {
    subnet_id = "${aws_subnet.prometheus-public-1.id}"
    route_table_id = "${aws_route_table.prometheus-public.id}"
}
# Associate Route table with Public subnet (1b)
resource "aws_route_table_association" "prometheus-public-2-a" {
    subnet_id = "${aws_subnet.prometheus-public-2.id}"
    route_table_id = "${aws_route_table.prometheus-public.id}"
}
# Associate Route table with Public subnet (1c)
resource "aws_route_table_association" "prometheus-public-3-a" {
    subnet_id = "${aws_subnet.prometheus-public-3.id}"
    route_table_id = "${aws_route_table.prometheus-public.id}"
}
