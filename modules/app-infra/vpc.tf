resource "aws_vpc" "this" {
  cidr_block       = var.network_cidr_block
  instance_tenancy = "dedicated"

  tags = {
    Name                       = "${var.filter_prefix}-${var.environment}"
    "${var.filter_prefix}/vpc" = var.environment
  }
}

