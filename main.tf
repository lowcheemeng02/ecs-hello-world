module "vpc_network" {
  source = "./modules/networking"

  proj_name = var.proj_name

  vpc_cidr = var.vpc_cidr

  availability_zones = var.availability_zones

}

module "compute_cap" {
  source = "./modules/ec2_capacity_provider"

  proj_name = var.proj_name

  key_pair_name = "${var.proj_name}-key-pair"

  instance_type = var.instance_type

  vpc_id = module.vpc_network.vpc_id

}