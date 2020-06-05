variable "name" {
  default = "my-cluster"
}

variable "filter_prefix" {
  default = "eks-cluster"
}

variable "environment" {
  default = "dev"
}

variable "region" {}

variable "min_nodes_per_region" {
  default = 1
}
variable "max_nodes_per_region" {
  default = 10
}

variable "eks_work_node_instance_types" {
  default = ["t3.medium"]
}
variable "mysql_engine" {
  default = "5.7"
}

variable "db_instance_class" {
  default = "db.t3.small"
}
