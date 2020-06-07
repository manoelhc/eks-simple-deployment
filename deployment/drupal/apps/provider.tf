provider "helm" {
  version        = "~> 0.10.4"
  install_tiller = true
  kubernetes {
    config_context = "wordpress-prod"
  }
}

provider "kubernetes" {
  config_context = "wordpress-prod"
}
provider "aws" {
  region = "us-east-1"
}
