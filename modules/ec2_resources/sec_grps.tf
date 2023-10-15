resource "aws_security_group" "ecs_secgrp" {

  name = "${var.proj_name}-secgrp"

  vpc_id = var.vpc_id

}

# security group rules are "allow" rules
# including an ip into the rule means allowing the traffic from that ip
# specifying a port range in the rule means allowing the traffic within that port range
resource "aws_security_group_rule" "ingress_rule" {
  type = "ingress"

  # this rule applies to traffic within the port range: "from_port" to "to_port"
  from_port = 80
  to_port   = 8080

  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # the ip range that this rule will allow
  security_group_id = aws_security_group.ecs_secgrp.id
}

# security group rules are "allow" rules
# including an ip into the rule means allowing the traffic from that ip
# specifying a port range in the rule means allowing the traffic within that port range
resource "aws_security_group_rule" "egress_rule" {
  type = "egress"

  # this rule applies to traffic within the port range: "from_port" to "to_port"
  from_port = 80
  to_port   = 8080

  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # the ip range that this rule will allow
  security_group_id = aws_security_group.ecs_secgrp.id
}