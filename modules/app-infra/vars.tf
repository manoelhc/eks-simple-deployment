variable "network_cidr_block" {
  default = "10.0.0.0/16"
}

variable "name" {
  default = "eks-cluster"
}

variable "filter_prefix" {
  default = "eks-cluster"
}

variable "environment" {
  default = "dev"
}

variable "subnet_cidr_newbits_start" {
  default = "8"
}

variable "subnet_start_at" {
  default = "1"
}

variable "region" {

}




