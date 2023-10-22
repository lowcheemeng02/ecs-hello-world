output "asg_arn" {
  value = aws_autoscaling_group.ecs_asg.arn
}

output "ecs_tg_arn" {
  value = aws_lb_target_group.ecs_tg.arn
}

output "sec_grp_id" {
  value = aws_security_group.ecs_secgrp.id
}

output "ami_selection" {
  value = data.aws_ami.ecs_ec2_ami.id
}