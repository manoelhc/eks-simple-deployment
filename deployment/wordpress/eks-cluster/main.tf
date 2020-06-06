data "aws_region" "current" {}

locals {
  filter_prefix = "drupal-cluster"
  environment   = "prod"
  region        = data.aws_region.current.name
}

module "cluster" {
  source                       = "../../../modules/app-cluster"
  name                         = "drupal"
  environment                  = local.environment
  filter_prefix                = local.filter_prefix
  region                       = local.region
  min_nodes_per_region         = 1
  max_nodes_per_region         = 10
  eks_work_node_instance_types = ["t3.medium"]
}
