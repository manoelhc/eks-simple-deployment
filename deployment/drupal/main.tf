data "aws_region" "current" {}

locals {
  project_name         = "drupal"
  worked_instance_type = "t3.medium"
  region               = data.aws_region.current.name
}

// Production environment setup
module "infra" {
  source = "../../modules/aws-netsec"
  vpc = {
    id  = aws_vpc.prod.id
    arn = aws_vpc.prod.arn
  }
  name                      = local.project_name
  environment               = "prod"
  subnet_cidr_newbits_start = "8"
  subnet_start_at           = "1"
  region                    = local.region
  admins                    = []
}

module "cluster" {
  source = "../../modules/aws-eks-cluster"
  vpc = {
    id  = aws_vpc.prod.id
    arn = aws_vpc.prod.arn
  }
  name                         = local.project_name
  environment                  = "prod"
  region                       = local.region
  min_nodes_per_region         = 2
  max_nodes_per_region         = 10
  eks_work_node_instance_types = ["t3.medium"]
  depends_on                   = [module.infra]
}
/*
module "services" {
  source      = "../../modules/k8s-services"
  cluster     = module.cluster.cluster
  name        = local.project_name
  environment = local.environment
  region      = local.region
  depends_on  = [module.cluster]
  vpc_id      = module.infra.vpc_id
}
*/
/*
module "apps" {
  source            = "../../modules/k8s-app"
  cluster           = module.cluster.cluster
  vpc_id            = module.infra.vpc_id
  name              = local.project_name
  data_subnets      = module.infra.data_subnets
  namespace         = "default"
  image             = "${local.image_name}"
  environment       = local.environment
  image_tag         = local.image_tag
  domain            = "drupal.aws"
  postgres_engine   = "11"
  region            = local.region
  db_instance_class = "db.t3.micro"
  k8s_context       = module.cluster.k8s_context
  depends_on        = [module.services]
}
*/
