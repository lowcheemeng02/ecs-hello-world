resource "aws_lb" "ecs_asg_lb" {
  name               = "${var.proj_name}-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_secgrp.id]
  subnets            = var.subnet_ids

  tags = {
    Name = "${var.proj_name}-ecs-alb"
  }
}


locals {
  port     = 80
  protocol = "HTTP"
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_asg_lb.arn
  port              = local.port # load balancer listens on port 80
  protocol          = local.protocol # load balancer listens for requests sent in this protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

# Your load balancer routes requests to the targets in a target group and performs health checks on the targets.
resource "aws_lb_target_group" "ecs_tg" {
  name     = "${var.proj_name}-ecs-lb-tg"
  port     = local.port
  protocol = local.protocol
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    path = "/"
  }
}
