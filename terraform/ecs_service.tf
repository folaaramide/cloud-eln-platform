########################################
# ECS Service
########################################

resource "aws_ecs_service" "app" {

  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn

  desired_count = 1

  launch_type = "FARGATE"

  enable_execute_command = true

  network_configuration {

    assign_public_ip = false

    security_groups = [
      aws_security_group.ecs.id
    ]

    subnets = [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]
  }

  load_balancer {

    target_group_arn = aws_lb_target_group.app.arn

    container_name = "cloud-eln"

    container_port = 5000
  }

  depends_on = [
    aws_lb_listener.http
  ]

  tags = local.common_tags
}