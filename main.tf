module "vpc" {
  source = "./modules/networking"

  proj_name = var.proj_name

  vpc_cidr = var.vpc_cidr
}