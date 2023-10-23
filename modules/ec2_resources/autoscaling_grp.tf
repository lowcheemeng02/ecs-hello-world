resource "aws_autoscaling_group" "ecs_asg" {
  name                = "${var.proj_name}-asg"
  vpc_zone_identifier = var.subnet_ids

  # availability_zones = var.availability_zones
  min_size         = 1
  max_size         = 3
  desired_capacity = 2
  # health_check_type  = "ELB"

  launch_template {
    id      = aws_launch_template.ecs_launch.id
    version = "$Latest" # can also be latest_version
  }

  # tag {
  #   key                 = "AmazonECSManaged"
  #   value               = true
  #   propagate_at_launch = true # propagate this tag to EC2 instances launched by this ASG
  # }

  # instance_refresh {
  #   strategy = "Rolling" # Strategy to use for instance refresh

  #   preferences {
  #     # Amount of capacity in the Auto Scaling group that must remain healthy during an instance refresh 
  #     # to allow the operation to continue, as a percentage of the desired capacity of the Auto Scaling group
  #     min_healthy_percentage = 50

  #     auto_rollback = true # Automatically rollback if instance refresh fails. Defaults to false. This option may only be set to true when specifying a launch_template
  #   }

  #   triggers = ["tag"]
  # }
}