variable "proj_name" {
  type = string
}

variable "asg_arn" {
  type = string
}

variable "ecs_tg_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "sec_grp_id" {
  type = string
}

variable "cluster_name" {
  type = string
}