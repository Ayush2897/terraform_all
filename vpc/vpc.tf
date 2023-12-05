resource "aws_vpc" "terraform" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terraform"
  }
}
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.terraform.id
  cidr_block              = element(var.public_subnet, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true


  tags = {
    Name = "public_subnet-$(data.aws_availability_zones.available.names[count.index])"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet)
  vpc_id                  = aws_vpc.terraform.id
  cidr_block              = element(var.private_subnet, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true


  tags = {
    Name = "private_subnet-$(data.aws_availability_zones.available.names[count.index])"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terraform.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "Public_route_table" {
  vpc_id = aws_vpc.terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public_route_table"
  }
}

resource "aws_route_table_association" "public_subnet" {
  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.Public_route_table.id
}

resource "aws_eip" "eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "gw NAT - eip"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "Private_route_table" {
  vpc_id = aws_vpc.terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Private_route_table"
  }
}

resource "aws_route_table_association" "private_subnet" {
  count          = length(var.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.Private_route_table.id
}