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

variable "cluster" {}

variable "vpc" {
  type = object({ id = string, arn = string })
}
