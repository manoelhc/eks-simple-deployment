resource "null_resource" "check-awscli" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} list-clusters"
  }
}

resource "null_resource" "check-kubectl" {
  provisioner "local-exec" {
    command = "kubectl"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 7
}

resource "aws_eks_cluster" "this" {
  name                      = local.cluster_name
  role_arn                  = "${aws_iam_role.cluster.arn}"
  version                   = "1.16.8"
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    subnet_ids = local.app_subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.

  depends_on = [
    "null_resource.check-awscli",
    "null_resource.check-kubectl",
    "aws_cloudwatch_log_group.this",
  ]
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${aws_eks_cluster.this.name}-main-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = local.app_subnet_ids

  instance_types = var.eks_work_node_instance_types

  scaling_config {
    desired_size = var.min_nodes_per_region
    min_size     = var.min_nodes_per_region
    max_size     = var.min_nodes_per_region
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.

  depends_on = [
    "aws_iam_role.node"
  ]
}

resource "null_resource" "setup-kubeconfig" {
  depends_on = ["aws_eks_cluster.this", "null_resource.check-awscli"]
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${local.cluster_name}"
  }
}
