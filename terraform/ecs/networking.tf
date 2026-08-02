########################################
# Availability Zones
########################################

data "aws_availability_zones" "available" {
  state = "available"
}

########################################
# VPC
########################################

resource "aws_vpc" "main" {

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
}

########################################
# Internet Gateway
########################################

resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-igw"
    }
  )
}

########################################
# Public Subnet 1
########################################

resource "aws_subnet" "public_1" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-public-1"
    }
  )
}

########################################
# Public Subnet 2
########################################

resource "aws_subnet" "public_2" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-public-2"
    }
  )
}

########################################
# Private Subnet 1
########################################

resource "aws_subnet" "private_1" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-private-1"
    }
  )
}

########################################
# Private Subnet 2
########################################

resource "aws_subnet" "private_2" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-private-2"
    }
  )
}

########################################
# Elastic IP for NAT Gateway
########################################

resource "aws_eip" "nat" {

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-nat-eip"
    }
  )
}

########################################
# NAT Gateway
########################################

resource "aws_nat_gateway" "main" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-nat"
    }
  )
}

########################################
# Public Route Table
########################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-public-rt"
    }
  )
}

########################################
# Private Route Table
########################################

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-private-rt"
    }
  )
}

########################################
# Public Route Table Associations
########################################

resource "aws_route_table_association" "public_1" {

  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {

  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

########################################
# Private Route Table Associations
########################################

resource "aws_route_table_association" "private_1" {

  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {

  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}