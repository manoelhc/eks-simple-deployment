data "aws_region" "current" {}

locals {
  filter_prefix = "wordpress-cluster"
  environment   = "prod"
  region        = data.aws_region.current.name
}

module "cluster" {
  source               = "../../../modules/app-cluster"
  name                 = "wordpress"
  environment          = "prod"
  filter_prefix        = local.filter_prefix
  region               = local.region
  min_nodes_per_region = 1
  max_nodes_per_region = 10
  mysql_engine         = "5.7"

  db_instance_class            = "db.t3.micro"
  eks_work_node_instance_types = ["t3.medium"]
}
