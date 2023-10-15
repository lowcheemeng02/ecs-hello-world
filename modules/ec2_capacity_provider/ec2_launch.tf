resource "aws_launch_template" "ecs_launch" {
  description = "${var.proj_name}-ec2-launch"

  name_prefix = "${var.proj_name}-ec2-launch"

  image_id = data.aws_ami.ecs_ec2_ami.id

  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.ecs_secgrp.id]

  key_name = aws_key_pair.push_public_key.key_name

  user_data = filebase64("${local.launch_script}")

  update_default_version = true

  ebs_optimized = true

  # EC2s run under instance profiles 
  # EC2s need to be given an instance profile so that they can assume the IAM roles (can be multiple) attached to the profile
  iam_instance_profile {
    name = local.instance_profile_name
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 10
      delete_on_termination = true
      volume_type           = "gp2"
    }
  }

  block_device_mappings {
    device_name = "/dev/sdb"
    ebs {
      volume_size           = 20
      delete_on_termination = true
      volume_type           = "gp3"
    }
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.proj_name}-ec2-launch"
    }
  }

}

# find the data for AMZ Linux 3 ami
data "aws_ami" "ecs_ec2_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

}

locals {
  launch_script = "${path.module}/scripts/ecs.sh"
}

resource "local_file" "launch_script" {
  filename = local.launch_script
  content = <<-EOF
  #!/bin/bash
  echo ECS_CLUSTER=${var.proj_name}-ecs-cluster >> /etc/ecs/ecs.config
  EOF
}

# resource "aws_instance" "foo" {
#   ami           = data.aws_ami.ecs_ec2_ami.id
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.ecs_secgrp.id]

#   subnet_id = element(var.subnet_ids, 1)

#   # root_block_device aka original storage that comes with EC2
#   root_block_device {
#     volume_size = 12
#     volume_type = "gp3"
#     delete_on_termination = true
#   }

#   # additional ebs storage
#   ebs_block_device {
#     device_name = "sdb"
#     volume_size = 30
#     volume_type = "gp2"
#     delete_on_termination = true
#   }

#   tags = {
#     Name = "${var.proj_name}-ec2"
#   }

#   depends_on = [ aws_security_group.ecs_secgrp ]
# }