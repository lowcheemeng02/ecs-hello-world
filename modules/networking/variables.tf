variable "proj_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

# variable "subnet_cidr_blocks" {
#   type = list(string)
# }

variable "availability_zones" {
  type = list(string)
}