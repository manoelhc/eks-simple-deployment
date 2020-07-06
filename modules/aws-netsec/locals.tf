data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  subnet_ids = concat(
    aws_subnet.ingress[*].cidr_block,
    aws_subnet.cache[*].cidr_block,
    aws_subnet.data[*].cidr_block,
    aws_subnet.systems[*].cidr_block,
    aws_subnet.app[*].cidr_block,
  )
  azs_all   = data.aws_availability_zones.available.names
  azs_count = length(data.aws_availability_zones.available.names)
}

