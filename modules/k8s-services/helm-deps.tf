
// Not Ready yet

resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring"
    }

    labels = {
      "istio-injection" = "enabled"
    }

    name = "monitoring"
  }
}

resource "null_resource" "helm-init" {
  provisioner "local-exec" {
    command = "helm init"
  }
}
/*
resource "helm_release" "monitoring" {
  name         = "monitoring"
  chart        = "stable/prometheus-operator"
  repository   = "https://kubernetes-charts.storage.googleapis.com"
  version      = "8.14.0"
  verify       = true
  force_update = true
  depends_on   = [kubernetes_namespace.monitoring, null_resource.helm-init]
}
*/
