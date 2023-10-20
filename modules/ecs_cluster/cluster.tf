resource "aws_ecs_cluster" "ecs_cluster" {

 name = "${var.proj_name}-cluster"

}