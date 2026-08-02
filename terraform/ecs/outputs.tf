########################################
# VPC
########################################

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

########################################
# Public Subnets
########################################

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

########################################
# Private Subnets
########################################

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

########################################
# NAT Gateway
########################################

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.main.id
}

########################################
# ECR
########################################

output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.app.repository_url
}

########################################
# ECS
########################################

output "ecs_cluster_name" {

  value = aws_ecs_cluster.main.name
}

output "ecs_cluster_arn" {

  value = aws_ecs_cluster.main.arn
}


########################################
# ECS Task Definition
########################################

output "task_definition_family" {
  value = aws_ecs_task_definition.app.family
}

########################################
# ECS Service
########################################

#output "ecs_service_name" {
#  description = "ECS Service Name"
#  value       = aws_ecs_service.app.name
#}

########################################
# RDS
########################################

output "rds_endpoint" {

  value = aws_db_instance.postgres.address
}

output "rds_database_name" {

  value = aws_db_instance.postgres.db_name
}