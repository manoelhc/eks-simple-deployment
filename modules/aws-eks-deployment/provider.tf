
data "aws_eks_cluster" "app" {
  name = "${var.name}-${var.environment}"
}

provider "kubernetes" {
  config_context_cluster = var.k8s_context
}
