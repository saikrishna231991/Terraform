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

variable "publicsubnet" {}
variable "privatesubnet" {}
variable "ec2_sg_name" {}

variable "securitygroup_egress_rules" {
  description = "The Ingress security group rules for the web servers."
  type = map
}

variable "securitygroup_ingress_rules" {
  description = "The Ingress security group rules for the web servers."
  type = map
}
 variable "igw_name" {
   type        = string
   description = "internet gate way name"
 }


# variable "web_security_group_rules" {
#   description = "The security group rules for the web servers."
#   type = object({
#     ingress = optional(map(object({
#       cidr_ipv4   = string
#       from_port   = number
#       ip_protocol = string
#       to_port     = number
#     })), {})
#     egress = optional(map(object({
#       cidr_ipv4   = string
#       from_port   = number
#       ip_protocol = string
#       to_port     = number
#     })), {})
#   })
# }
# variable "igv_name" {
#   type        = string
#   description = "internet gate way name"
# }
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


