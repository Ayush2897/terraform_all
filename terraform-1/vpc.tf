resource "aws_vpc" "terraform" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform"
  }
}
resource "aws_subnet" "subnet-public-1" {
  vpc_id     = "${aws_vpc.terraform.id}"
  cidr_block = "192.168.1.0/24"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = "${var.aws_vailability_zone}" 

  tags = {
    Name = "subnet-public-1"
  }
}

resource "aws_internet_gateway" "gw_teraform" {
  vpc_id = "${aws_vpc.terraform.id}"

  tags = {
    Name = "gw_teraform"
  }
}

resource "aws_route_table" "route-table-subnet-1" {
  vpc_id = "${aws_vpc.terraform.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw_teraform.id}"
  }

  tags = {
    Name = "route-table-subnet-1"
  }
}

resource "aws_route_table_association" "association-subnet-1" {
  subnet_id      = "${aws_subnet.subnet-public-1.id}"
  route_table_id = "${aws_route_table.route-table-subnet-1.id}"
}

