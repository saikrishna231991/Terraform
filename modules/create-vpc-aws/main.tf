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
