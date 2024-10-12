resource "aws_instance" "test" {
  ami           = var.ami_value
  instance_type = var.instance_type

  tags = {
    Name = "testing"
  }
}
