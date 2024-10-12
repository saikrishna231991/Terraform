terraform {
  backend "s3" {
    bucket = "s3-bucket-sk-89899versioning"
    key    = "terraform/test.tfstate"
    region = "us-east-1"
    dynamodb_table = "Terraform-lock"
  }
}
