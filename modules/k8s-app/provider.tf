provider "kubernetes" {
  config_context_cluster = "${var.name}-${var.environment}"
}
