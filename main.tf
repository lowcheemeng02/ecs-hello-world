# VPC, subnets, route table, igw
module "vpc_network" {
  source = "./modules/networking"

  proj_name = var.proj_name

  vpc_cidr = var.vpc_cidr

  availability_zones = var.availability_zones

}

# EC2 launch template, IAM permissions for EC2s to do stuff that EC2s in a ECS need to do, 
# security group, auto-scaling group, application load balancer
module "ec2_resources" {
  source = "./modules/ec2_resources"

  proj_name = var.proj_name

  key_pair_name = "${var.proj_name}-key-pair"

  instance_type = var.instance_type

  vpc_id = module.vpc_network.vpc_id

  subnet_ids = module.vpc_network.subnet_ids

  availability_zones = var.availability_zones
}