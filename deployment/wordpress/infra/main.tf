data "aws_region" "current" {}

locals {
  filter_prefix = "drupal-cluster"
  environment   = "prod"
  region        = data.aws_region.current.name
}

module "infra" {
  source                    = "../../../modules/app-infra"
  filter_prefix             = local.filter_prefix
  name                      = "drupal-prod"
  environment               = local.environment
  network_cidr_block        = "10.0.0.0/16"
  subnet_cidr_newbits_start = "8"
  subnet_start_at           = "1"
  region                    = local.region
}
