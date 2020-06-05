module "apps" {
  source        = "../../../modules/k8s-app"
  name          = "wordpress"
  namespace     = "wordpress"
  image         = "wordpress"
  environment   = local.environment
  filter_prefix = local.filter_prefix
  image_tag     = "5.4.1-php7.2-apache"
}
