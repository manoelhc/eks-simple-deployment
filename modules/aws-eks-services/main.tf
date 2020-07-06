data "aws_iam_role" "ingress" {
  name = "${var.cluster}-main-ingress-role"
}

data "aws_iam_role" "node" {
  name = "${var.cluster}-main-node-role"
}

data "aws_iam_role" "cluster" {
  name = "${var.cluster}-main-cluster-role"
}

