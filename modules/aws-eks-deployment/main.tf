
locals {
  cluster_name = "${var.name}-${var.environment}"
}

resource "kubernetes_namespace" "app" {
  metadata {
    labels = {
      "istio-injection" = "enabled"
    }

    name = var.namespace
  }
}

resource "kubernetes_secret" "app" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  data = {
    DB_HOST           = aws_db_instance.this.endpoint
    POSTGRES_USER     = aws_ssm_parameter.db-app-username.value
    POSTGRES_PASSWORD = aws_ssm_parameter.db-app-password.value
    POSTGRES_DB       = aws_ssm_parameter.db-dbname.value
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    namespace = var.namespace
    name      = var.name
    labels = {
      app = var.name
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/path"   = "/metrics"
          "prometheus.io/port"   = "8080"
        }
        labels = {
          app = var.name
        }
      }

      spec {

        container {
          image = "${var.image}:${var.image_tag}"
          name  = var.name
          port {
            container_port = 80
          }
          env_from {
            secret_ref {
              name = var.name
            }
          }
          resources {
            limits {
              cpu    = "1"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "150Mi"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.app, kubernetes_secret.app, aws_db_instance.this]
}

resource "kubernetes_horizontal_pod_autoscaler" "app" {
  metadata {
    namespace = var.namespace
    name      = var.name
  }

  spec {
    max_replicas                      = 20
    min_replicas                      = 2
    target_cpu_utilization_percentage = 80
    scale_target_ref {
      kind = "Deployment"
      name = var.name
    }
  }
  depends_on = [kubernetes_deployment.app]
}

resource "kubernetes_service" "app" {
  metadata {
    namespace = var.namespace
    name      = var.name
  }
  spec {
    selector = {
      app = var.name
    }
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.app]
}


resource "kubernetes_ingress" "ingress" {
  metadata {
    namespace = var.namespace
    name      = var.name
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }

    labels = {
      app = "${var.name}-ingress"
    }
  }
  spec {
    rule {
      host = var.domain
      http {
        path {
          path = "/*"
          backend {
            service_name = var.name
            service_port = 80
          }
        }
      }
    }
  }
  depends_on = [kubernetes_deployment.app]
}
