data "aws_region" "current" {}

locals {
  filter_prefix = "drupal-cluster"
  environment   = "prod"
  region        = data.aws_region.current.name
}

module "services" {
  source        = "../../../modules/k8s-services"
  name          = "drupal"
  environment   = local.environment
  filter_prefix = local.filter_prefix
  region        = local.region
}
