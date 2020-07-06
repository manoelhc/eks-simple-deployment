locals {
  prefix = "${title(var.name)}-${title(var.environment)}-EKS"
}

resource "aws_subnet" "ingress" {
  count             = local.azs_count
  vpc_id            = var.vpc.id
  cidr_block        = cidrsubnet(var.network_cidr_block, var.subnet_cidr_newbits_start, ((0 * local.azs_count) + count.index + var.subnet_start_at))
  availability_zone = local.azs_all[count.index]

  tags = {
    Name        = "${local.prefix}-Ingress-Subnet"
    Project     = var.name
    Environment = var.environment
  }
}

resource "aws_subnet" "cache" {
  count             = local.azs_count
  vpc_id            = var.vpc.id
  cidr_block        = cidrsubnet(var.network_cidr_block, var.subnet_cidr_newbits_start, ((1 * local.azs_count) + count.index + var.subnet_start_at))
  availability_zone = local.azs_all[count.index]

  tags = {
    Name        = "${local.prefix}-EKS-Cache-Subnet"
    Project     = var.name
    Environment = var.environment

  }
}

resource "aws_subnet" "data" {
  count             = local.azs_count
  vpc_id            = var.vpc.id
  cidr_block        = cidrsubnet(var.network_cidr_block, var.subnet_cidr_newbits_start, ((2 * local.azs_count) + count.index + var.subnet_start_at))
  availability_zone = local.azs_all[count.index]

  tags = {
    Name        = "${local.prefix}-EKS-Data-Subnet"
    Project     = var.name
    Environment = var.environment

  }
}

output "data_subnets" {
  value       = aws_subnet.data[*].id
  description = "AWS Subnets"
}


resource "aws_subnet" "systems" {
  count             = local.azs_count
  vpc_id            = var.vpc.id
  cidr_block        = cidrsubnet(var.network_cidr_block, var.subnet_cidr_newbits_start, ((3 * local.azs_count) + count.index + var.subnet_start_at))
  availability_zone = local.azs_all[count.index]

  tags = {
    Name        = "${local.prefix}-EKS-Data-Subnet"
    Project     = var.name
    Environment = var.environment
  }
}

resource "aws_subnet" "app" {
  count                   = local.azs_count
  vpc_id                  = var.vpc.id
  cidr_block              = cidrsubnet(var.network_cidr_block, var.subnet_cidr_newbits_start, ((4 * local.azs_count) + count.index + var.subnet_start_at))
  availability_zone       = local.azs_all[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name                                = "${local.prefix}-EKS-App-Subnet"
    Project                             = var.name
    Environment                         = var.environment
    "kubernetes.io/cluster/${var.name}" = "shared"
    "kubernetes.io/role/elb"            = 1
  }
}
