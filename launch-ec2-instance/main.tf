module "ec2_instance" {
   source = "../modules/ec2-instnace"
   ami_value="ami-0fff1b9a61dec8a5f"
   instance_type = "t2.micro"
}
