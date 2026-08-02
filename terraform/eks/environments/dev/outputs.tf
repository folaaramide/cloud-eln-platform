output "account_id" {

  value = data.aws_caller_identity.current.account_id

}

output "caller_arn" {

  value = data.aws_caller_identity.current.arn

}

output "aws_region" {

  value = data.aws_region.current.name

}

output "project_name" {

  value = var.project_name

}

output "environment" {

  value = var.environment

}