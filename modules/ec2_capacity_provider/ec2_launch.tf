# resource "aws_launch_template" "ecs_launch" {
#   name_prefix = "${var.proj_name}-ec2-launch"

#   image_id = data.aws_ami.ecs_ec2_ami.id

#   instance_type = var.instance_type

#   vpc_security_group_ids = [aws_security_group.ecs_secgrp.id]

#   key_name = aws_key_pair.push_public_key.key_name

#   user_data = filebase64("${path.module}/scripts/ecs.sh")

#   ebs_optimized = true

#   iam_instance_profile {
#     name = "ecsInstanceRole"
#   }

#   block_device_mappings {
#     device_name = "/dev/sda1"
#     ebs {
#       volume_size           = 10
#       delete_on_termination = true
#       volume_type           = "gp2"
#     }
#   }

#   monitoring {
#     enabled = true
#   }

#   tag_specifications {
#     resource_type = "ec2-instance"

#     tags = {
#       Name = "${var.proj_name}-ec2-launch"
#     }
#   }

# }

# # find the data for AMZ Linux 3 ami
# data "aws_ami" "ecs_ec2_ami" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-*-x86_64"]
#   }

# }
