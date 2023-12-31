variable "key_pair_name" {
  type = string
}

variable "proj_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "allow_ec2_direct_access" {
  type = bool
}