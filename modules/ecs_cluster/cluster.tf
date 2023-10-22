resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

# define a aws_ecs_capacity_provider and link it to the ASG
# if there is another asg, then another aws_ecs_capacity_provider resource can be created to establish a link to it
resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "${var.proj_name}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.asg_arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED" # Whether auto scaling is managed by ECS
      target_capacity           = 3
    }
  }
}

# aws_ecs_cluster_capacity_providers links aws_ecs_capacity_providers with the cluster
# can have more than one aws_ecs_capacity_provider linked to a cluster
resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1   # The number of tasks, at a minimum, to run on the specified capacity provider
    weight            = 100 # 100% of launched tasks that should use this specified capacity provider, because there is only one capacity provider
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
  }
}