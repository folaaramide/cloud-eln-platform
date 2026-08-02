variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "cloud-eln-platform"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

#############################
# Networking
#############################

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "Public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "Public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "Private subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "Private subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}

#############################
# Database
#############################

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "cloudeln"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "container_image" {
  description = "Container image URI"
  type        = string
  default     = "PLACEHOLDER"
}