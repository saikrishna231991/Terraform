variable "vpc_name" {
  type        = string
  description = "test-project 1"
}

variable "cidr" {
  type        = string
  description = "cidr values"
}

variable "publicsubnetname" {
  description = "Prefix used for all resources names"
  default     = "public-subnet"
}

variable "privatesubnetname" {
  description = "Prefix used for all resources names"
  default     = "private-subnet"
}



# variable "public-subnet" {
#   type = map(object({
#     cidr = list(string)
#   }))
# }

# variable "private-subnet" {
#   type = map(object({
#     cidr = list(string)
#   }))
# }

variable "publicsubnet" {}
variable "privatesubnet" {}
