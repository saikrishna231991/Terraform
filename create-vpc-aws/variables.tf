variable "vpc_name" {
  type        = string
  description = "test-project 1"
}

variable "public_subnet" {
  type        = list(string)
  description = "cidr public subnet values"
}

variable "private_subnet" {
  type        = list(string)
  description = "cidr private subnet values"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones to use"
}