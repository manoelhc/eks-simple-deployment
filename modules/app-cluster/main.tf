data "aws_subnet" "private-apps" {
  filter {
    name   = "tag:${var.filter_prefix}/private-app"
    values = [var.environment]
  }
}
data "aws_subnet" "private-data" {
  filter {
    name   = "tag:${var.filter_prefix}/private-data"
    values = [var.environment]
  }
}

locals {
  app_subnet_ids  = [for s in data.aws_subnet.private-apps : s.id]
  data_subnet_ids = [for s in data.aws_subnet.private-data : s.id]
  cluster_name    = "${var.name}-${var.environment}"
}

output "endpoint" {
  value = "${aws_eks_cluster.this.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.this.certificate_authority.0.data}"
}

