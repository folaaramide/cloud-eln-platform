variable "aws_region" {

  description = "AWS region for deployment"

  type = string

  default = "eu-west-2"

}

variable "project_name" {

  description = "Project name"

  type = string

  default = "cloud-eln"

}

variable "environment" {

  description = "Deployment environment"

  type = string

  default = "dev"

}