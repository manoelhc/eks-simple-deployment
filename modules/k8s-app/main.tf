
resource "kubernetes_namespace" "app" {
  metadata {
    annotations = {
      name = "${var.namespace}-${var.environment}"
    }

    labels = {
      "istio-injection" = "enabled"
    }

    name = var.namespace
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    namespace = var.namespace
    annotations = {
      created = "${timestamp()}"
    }
    name = var.name
    labels = {
      app = var.name
    }
  }

  spec {
    replicas = 2

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

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        annotations = {
          "prometheus.io/scrape"      = "true"
          "prometheus.io/path"        = "/metrics"
          "prometheus.io/port"        = "8080"
          "${var.name}/last-deployed" = "${timestamp()}"
        }
        labels = {
          app = var.name
        }
      }

      spec {
        container {
          image = "${var.image}:${var.image_tag}"
          name  = var.name
          port { container_port = 80 }
          env_from {
            secret_ref {
              name = local.st_consumer_name
            }
          }
        }
      }
    }
  }
  depends_on = ["kubernetes_namespace.app"]
}

resource "kubernetes_secret" "app" {
  metadata {
    name = var.name
  }
  data = {
    WORDPRESS_DB_HOST     = data.aws_ssm_parameter.db-hostname.value
    WORDPRESS_DB_USER     = data.aws_ssm_parameter.db-username.value
    WORDPRESS_DB_PASSWORD = data.aws_ssm_parameter.db-password.value
    WORDPRESS_DB_NAME     = data.aws_ssm_parameter.db-dbname.value
  }
}


resource "kubernetes_horizontal_pod_autoscaler" "app" {
  metadata {
    name = var.name
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
}

resource "kubernetes_service" "app" {
  metadata {
    name = var.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.app.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_ingress" "app" {
  metadata {
    name = var.name
  }

  spec {

    backend {
      service_name = var.name
      service_port = 80
    }

    rule {
      host = "host.myblog"
      http {
        path {
          backend {
            service_name = var.name
            service_port = 80
          }
          path = "/"
        }
      }
    }
    tls {
      secret_name = "tls-secret"
    }
  }
}

