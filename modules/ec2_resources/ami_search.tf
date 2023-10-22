# find the data for AMZ Linux 3 ami
data "aws_ami" "ecs_ec2_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*-x86_64"] # use an ECS optimized AMI, not the vanilla AMZ Linux 3 AMI
  }

}