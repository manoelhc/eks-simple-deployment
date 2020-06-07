data "aws_region" "current" {}

locals {
  filter_prefix = "drupal-cluster"
  environment   = "prod"
  region        = data.aws_region.current.name
}

module "apps" {
  source            = "../../../modules/k8s-app"
  name              = "drupal"
  namespace         = "drupal"
  image             = "drupal"
  environment       = local.environment
  filter_prefix     = local.filter_prefix
  image_tag         = "8.8.7-apache"
  domain            = "drupal.aws"
  postgres_engine   = "11"
  region            = local.region
  db_instance_class = "db.t3.micro"
}
