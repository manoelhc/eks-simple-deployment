
data "aws_eks_cluster" "app" {
  name = var.cluster
}

provider "kubernetes" {
  config_context_cluster = var.cluster
}

provider "helm" {

}
