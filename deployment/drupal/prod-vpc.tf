resource "aws_vpc" "prod" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    "${local.project_name}/vpc" = "prod"
    Project                     = local.project_name
    Environment                 = "prod"
  }
}

resource "aws_internet_gateway" "prod" {
  vpc_id = aws_vpc.prod.id

  tags = {
    "${local.project_name}/igw" = "prod"
    Project                     = local.project_name
    Environment                 = "prod"
  }
}

data "aws_route_table" "prod" {
  route_table_id = aws_vpc.prod.main_route_table_id
}

resource "aws_route" "prod" {
  route_table_id         = data.aws_route_table.prod.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.prod.id
}
