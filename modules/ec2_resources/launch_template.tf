resource "aws_launch_template" "ecs_launch" {
  description = "${var.proj_name}-ec2-launch"

  name_prefix = "${var.proj_name}-ec2-launch"

  image_id = data.aws_ami.ecs_ec2_ami.id

  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.ecs_secgrp.id]

  key_name = aws_key_pair.push_public_key.key_name

  user_data = base64encode(data.template_file.launch_script.rendered)

  # update_default_version = true

  # ebs_optimized = true

  # EC2s run under instance profiles
  # EC2s need to be given an instance profile so that they can assume the IAM roles (can be multiple) attached to the profile
  iam_instance_profile {
    name = local.instance_profile_name
  }

  # block_device_mappings {
  #   device_name = "/dev/xvda" # cannot be "/dev/sda1" for some ami
  #   ebs {
  #     volume_size           = 8
  #     delete_on_termination = true
  #     volume_type           = "gp3"
  #   }
  # }

  block_device_mappings {
    device_name = "/dev/sdf"
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

  depends_on = [
    data.template_file.launch_script
  ]

}

locals {
  launch_script = "${path.module}/scripts/ecs.sh"
}

# resource "local_file" "launch_script" {
#   filename = local.launch_script
#   content  = <<-EOF
#   #!/bin/bash
#   echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
#   EOF
# }

data "template_file" "launch_script" {
  template = file("${local.launch_script}")

  vars = {
    cluster_name = var.cluster_name
  }
}

