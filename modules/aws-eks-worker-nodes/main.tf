locals {
  app_subnet_ids  = data.aws_subnet_ids.public-apps.ids
  data_subnet_ids = data.aws_subnet_ids.private-data.ids
  cluster_name    = "${var.name}-${var.environment}"
}

data "aws_subnet_ids" "public-apps" {
  vpc_id = var.vpc.id
  tags = {
    "${var.filter_prefix}/public-app-subnet" = var.environment
  }
}
data "aws_subnet_ids" "private-data" {
  vpc_id = var.vpc.id
  tags = {
    "${var.filter_prefix}/private-data-subnet" = var.environment
  }
}

resource "null_resource" "setup-kubeconfig" {
  depends_on = [aws_eks_node_group.this]
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${local.cluster_name} --alias ${local.cluster_name}"
  }
}



