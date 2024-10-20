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

  depends_on = [aws_subnet.private_subnet]
}

# create a security-groups
resource "aws_security_group" "ec2_sg_ssh_http" {
  name        = var.ec2_sg_name
  description = "Enable the Port 22 and Port 80"
  vpc_id      = aws_vpc.test-vpc.id

  # ingress = {
  #   ip_protocol       = "tcp" # protocol number is 6 for tcp to specifiy all (VPC only) Use -1 to specify all protocols
  #   cidr_blocks         = ["0.0.0.0/0"]
  #   for_each          = var.securitygroupingressrules.ingress
  #   from_port         = each.value.from_port
  #   to_port           = each.value.to_port 
  # }
}

resource "aws_vpc_security_group_ingress_rule" "ingress-rules" {
  security_group_id = aws_security_group.ec2_sg_ssh_http.id
  ip_protocol       = "tcp" # protocol number is 6 for tcp to specifiy all (VPC only) Use -1 to specify all protocols
  for_each          = var.securitygroupingressrules
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_ipv4         = each.value.cidr_ipv4
  description       = each.value.discription
}