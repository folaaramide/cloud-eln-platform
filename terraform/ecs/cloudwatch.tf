resource "aws_cloudwatch_log_group" "ecs" {

  name = "/ecs/${var.project_name}"

  retention_in_days = 14

  tags = local.common_tags
}