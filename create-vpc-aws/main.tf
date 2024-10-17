module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = var.private_subnet
  public_subnets  = var.public_subnet

}