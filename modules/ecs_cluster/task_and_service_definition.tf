resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = "${var.proj_name}-ecs-task"
  network_mode       = "awsvpc" # This tells the ECS cluster to use the VPC networking, alternative "bridge", "host"
  execution_role_arn = data.aws_iam_role.ecsTaskExecutionRole.arn
  cpu                = 256

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }


  container_definitions = jsonencode([
    {
      name      = local.container_name # The name of a container
      image     = var.container_image  # repository-url/image:tag
      cpu       = 256                  # The number of cpu units the Amazon ECS container agent reserves for the container. Amazon ECS uses a standard unit of measure for CPU resources called CPU units. 1024 CPU units is the equivalent of 1 vCPU
      memory    = 512                  # The amount (in MiB) of memory to present to the container
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

locals {
  container_name = "flaskapp"
}

data "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
}


resource "aws_ecs_service" "ecs_service" {
  name            = "${var.proj_name}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2 # The number of deployment replicas for the task

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.sec_grp_id]
  }

  force_new_deployment = true

  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.ecs_tg_arn
    container_name   = local.container_name
    container_port   = 80
  }

}