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
    Name = var.igw_name
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

# create a security-groups 1
resource "aws_security_group" "create_security_group_1" {
  name        = var.Security_Group_Name
  description = "Generall purpose Security Group"
  vpc_id      = aws_vpc.test-vpc.id

}

#  create a security-groups 2
resource "aws_security_group" "create_security_group_2" {
  name        = var.Security_Group_Name_1
  description = "Jenkins purpose Security Group"
  vpc_id      = aws_vpc.test-vpc.id

}


resource "aws_vpc_security_group_ingress_rule" "ingress-rules" {
  security_group_id = aws_security_group.create_security_group_1.id
  for_each          = var.securitygroup_ingress_rules
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.protocol
  description       = each.value.discription
}

resource "aws_vpc_security_group_egress_rule" "egress-rules" {
  security_group_id = aws_security_group.create_security_group_1.id
  for_each          = var.securitygroup_egress_rules
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.protocol
  description       = each.value.discription

}


resource "aws_vpc_security_group_ingress_rule" "jenkins-ingress-rules" {
  security_group_id = aws_security_group.create_security_group_2.id
  for_each          = var.Jenkins_security_group
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.protocol
  description       = each.value.discription
}

# install jenkins

resource "aws_key_pair" "TF_KEY" {
  key_name   = "TF_KEY"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-KEY" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}

resource "aws_instance" "jenkins_ec2_instance_ip" {
  ami           = var.ami_value
  instance_type = var.instance_type
  key_name      = "TF_KEY"
  # key_name                    = aws_key_pair.my_key_pair.key_name
  for_each                    = toset([for subnet in aws_subnet.public_subnet : subnet.id])
  subnet_id                   = each.value
  vpc_security_group_ids      = [aws_security_group.create_security_group_2.id, aws_security_group.create_security_group_1.id]
  associate_public_ip_address = true
  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}