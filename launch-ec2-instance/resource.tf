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
