output "ingress_subnet_ids" {
  value       = aws_subnet.ingress[*].id
  description = "Ingress subnet ids list"
}

output "app_subnet_ids" {
  value       = aws_subnet.app[*].id
  description = "App subnet ids list"
}

output "data_subnet_ids" {
  value       = aws_subnet.data[*].id
  description = "Data subnet ids list"
}

output "cache_subnet_ids" {
  value       = aws_subnet.cache[*].id
  description = "Cache subnet ids list"
}

output "all_subnet_ids" {
  value       = local.subnet_ids
  description = "All subnet ids list"
}

output "vpc_id" {
  value       = var.vpc.id
  description = "VPC id"
}
