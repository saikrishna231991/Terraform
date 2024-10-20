vpc_name = "my-vpc-test1"
cidr     = "10.0.0.0/16"
# public_subnet  = ["10.0.101.0/24", "10.0.102.0/24"]
# private_subnet = ["10.0.1.0/24", "10.0.2.0/24"]
# azs            = ["us-east-1a", "us-east-1b"]

 igw_name = "test-igw"

# public-subnet = {
#   public_subnet-1 = {
#     cidr = ["10.0.101.0/24", "10.0.102.0/24"]
#   }
# }

# private-subnet = {
#   private_subnet-1 = {
#     cidr = ["10.0.1.0/24", "10.0.2.0/24"]
#   }
# }

privatesubnet = {
  "us-east-1a" = "10.0.1.0/24"
  "us-east-1b" = "10.0.2.0/24"
}

publicsubnet = {
  "us-east-1a" = "10.0.101.0/24"
  "us-east-1b" = "10.0.102.0/24"
}

ec2_sg_name = "test-securitygroup"

securitygroup_ingress_rules = {
    "ssh-public-subnet" = {
      cidr_ipv4 = "0.0.0.0/0"
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      discription = "SSH"
    }
    "http-public-subnet" = {
      cidr_ipv4 = "0.0.0.0/0"
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      discription = "HTTP"
    }
    "https-public-subnets" = {
      cidr_ipv4 = "0.0.0.0/0"
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      discription = "HTTPS"
    }
  }

securitygroup_egress_rules = {
    "ssh-public-subnet" = {
      cidr_ipv4 = "0.0.0.0/0"
      from_port = 0
      to_port   = 0
      protocol = -1
      discription = "Allow all outgoing requests"
    }
}
