data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs_count = 3
}

resource "aws_subnet" "public-ingress" {
  count             = local.azs_count
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = cidrsubnet(var.network_cidr_block, var.subnet_cidr_newbits_start, ((0 * local.azs_count) + count.index + var.subnet_start_at))
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                         = "EKS-Public-Ingress-Subnet-${var.name}"
    "${var.filter_prefix}/public-ingress-subnet" = var.environment
  }
}

resource "aws_subnet" "private-cache" {
  count             = local.azs_count
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = cidrsubnet(var.network_cidr_block, var.subnet_cidr_newbits_start, ((1 * local.azs_count) + count.index + var.subnet_start_at))
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                       = "EKS-Public-Cache-Subnet-${var.name}"
    "${var.filter_prefix}/public-cache-subnet" = var.environment
  }
}

resource "aws_subnet" "private-data" {
  count             = local.azs_count
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = cidrsubnet(var.network_cidr_block, var.subnet_cidr_newbits_start, ((2 * local.azs_count) + count.index + var.subnet_start_at))
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                       = "EKS-Private-Data-Subnet-${var.name}"
    "${var.filter_prefix}/private-data-subnet" = var.environment
  }
}

resource "aws_subnet" "private-systems" {
  count             = local.azs_count
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = cidrsubnet(var.network_cidr_block, var.subnet_cidr_newbits_start, ((3 * local.azs_count) + count.index + var.subnet_start_at))
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                          = "EKS-Private-Data-Subnet-${var.name}"
    "${var.filter_prefix}/private-systems-subnet" = var.environment
  }
}

resource "aws_subnet" "private-app" {
  count             = local.azs_count
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = cidrsubnet(var.network_cidr_block, var.subnet_cidr_newbits_start, ((4 * local.azs_count) + count.index + var.subnet_start_at))
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                      = "EKS-Private-App-Subnet-${var.name}"
    "${var.filter_prefix}/private-app-subnet" = var.environment
  }
}
