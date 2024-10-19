resource "aws_vpc" "test-vpc" {

  cidr_block = var.cidr

  tags = {
    Name = var.vpc_name

  }
}
resource "aws_subnet" "public_subnet" {
  for_each          = var.publicsubnet
  vpc_id            = aws_vpc.test-vpc.id
  availability_zone = each.key
  cidr_block        = each.value
  tags = {
    Name = "${var.publicsubnetname}-${each.key}"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each          = var.privatesubnet
  vpc_id            = aws_vpc.test-vpc.id
  availability_zone = each.key
  cidr_block        = each.value
  tags = {
    Name = "${var.privatesubnetname}-${each.key}"
  }
}

resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id
  tags = {
    Name = "test-igw-1"
  }
}

resource "aws_route_table" "test-public-routetable" {
  vpc_id = aws_vpc.test-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }
  tags = {
    Name = "test-public-routetable"
  }
}

resource "aws_route_table_association" "test-assocoiate-publicsubnet" {
  for_each       = toset([for subnet in aws_subnet.public_subnet : subnet.id])
  subnet_id      = each.value
  route_table_id = aws_route_table.test-public-routetable.id
}

resource "aws_route_table" "test-private-subnets-route-table" {
  vpc_id = aws_vpc.test-vpc.id
  tags = {
    Name = "test-private-routetable"
  }
}

resource "aws_route_table_association" "test-assocoiate-privatesubnet" {
  for_each       = toset([for subnet in aws_subnet.private_subnet : subnet.id])
  subnet_id      = each.value
  route_table_id = aws_route_table.test-private-subnets-route-table.id
}