locals {
  app_subnet_ids  = data.aws_subnet_ids.private-apps.ids
  data_subnet_ids = data.aws_subnet_ids.private-data.ids
  cluster_name    = "${var.name}-${var.environment}"
}

data "aws_vpc" "vpc" {
  tags = {
    "${var.filter_prefix}/vpc" = var.environment
  }
}

data "aws_subnet_ids" "private-apps" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    "${var.filter_prefix}/private-app-subnet" = var.environment
  }
}
data "aws_subnet_ids" "private-data" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    "${var.filter_prefix}/private-data-subnet" = var.environment
  }
}

