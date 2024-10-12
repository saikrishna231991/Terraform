variable "ami_value" {
   discription = "value of ami"
}

variable "instance_type" {
   discription = "type of ec2 instance"
}
variable "s3_bucket_name" {
   discription = "name of th es3 bucket"
}

resource "aws_instance" "test" {
  ami           - var.ami_value
  instance_type = var.instance_type

  tags = {
    Name = "testing"
  }
}
resource "aws_s3_bucket" "s3-buucket-versioning" {
  bucket = var.s3_bucket_name
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "Terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
