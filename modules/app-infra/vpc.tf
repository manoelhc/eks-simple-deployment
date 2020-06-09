resource "aws_vpc" "this" {
  cidr_block           = var.network_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name                       = "${var.filter_prefix}-${var.environment}"
    "${var.filter_prefix}/vpc" = var.environment
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name                       = "${var.filter_prefix}-${var.environment}"
    "${var.filter_prefix}/igw" = var.environment
  }
}
data "aws_route_table" "selected" {
  route_table_id = aws_vpc.this.main_route_table_id
}

resource "aws_route" "route" {
  route_table_id         = data.aws_route_table.selected.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
