resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.Public_subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.Public_subnet, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Public_subnet"
  }
}
resource "aws_subnet" "private" {
  count             = length(var.Private_subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.Private_subnet, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Private_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}
resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "nat"
  }
  depends_on = [aws_eip.eip]
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.Private_subnet)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "private_route_table"
  }
}
resource "aws_route_table" "public_route_table" {
  count  = length(var.Public_subnet)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  count          = length(var.Public_subnet)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id
}
resource "aws_route_table_association" "private_route_association" {
  count          = length(var.Private_subnet)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

