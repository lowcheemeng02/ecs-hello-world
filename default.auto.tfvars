region = "us-west-2"

vpc_cidr = "30.0.0.0/16"

proj_name = "hello-ecs"

container_image = "255945442255.dkr.ecr.us-west-2.amazonaws.com/flaskapp:latest"

# subnet_cidr_blocks = [ "30.0.0.0/24", "30.0.1.0/24" ]

instance_type = "t2.micro"

availability_zones = ["us-west-2a", "us-west-2b"]

allow_ec2_direct_access = true