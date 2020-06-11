locals {
  cluster_name = "${var.name}-${var.environment}"
}

data "aws_iam_role" "ingress" {
  name = "${local.cluster_name}-main-ingress-role"
}

data "aws_iam_role" "node" {
  name = "${local.cluster_name}-main-node-role"
}

data "aws_iam_role" "cluster" {
  name = "${local.cluster_name}-main-cluster-role"
}
