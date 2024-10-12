resource "aws_instance" "test" {
  ami           = "ami-0fff1b9a61dec8a5f"
  instance_type = "t2.micro"

  tags = {
    Name = "testing"
  }
}
resource "aws_s3_bucket" "s3-buucket-versioning" {
  bucket = "s3-bucket-sk-89899versioning"
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
