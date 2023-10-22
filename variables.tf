variable "proj_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

# variable "subnet_cidr_blocks" {
#   type = list(string)
# }

variable "instance_type" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "region" {
  type = string
}

variable "container_image" {
  type = string
}