
locals {
  app_subnet_ids  = data.aws_subnet_ids.public-apps.ids
  data_subnet_ids = data.aws_subnet_ids.private-data.ids
  cluster_name    = "${var.name}-${var.environment}"
}

data "aws_vpc" "vpc" {
  tags = {
    "${var.filter_prefix}/vpc" = var.environment
  }
}

data "aws_subnet_ids" "public-apps" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    "${var.filter_prefix}/public-app-subnet" = var.environment
  }
}
data "aws_subnet_ids" "private-data" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    "${var.filter_prefix}/private-data-subnet" = var.environment
  }
}

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

resource "kubernetes_secret" "app" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  data = {
    /*
    DB_HOST           = aws_db_instance.this.endpoint
    POSTGRES_USER     = aws_ssm_parameter.db-app-username.value
    POSTGRES_PASSWORD = aws_ssm_parameter.db-app-password.value
    POSTGRES_DB       = aws_ssm_parameter.db-dbname.value*/
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
  depends_on = [kubernetes_namespace.app, kubernetes_secret.app]
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
}

resource "kubernetes_service" "app" {
  metadata {
    namespace = var.namespace
    name      = var.name
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


resource "kubernetes_cluster_role" "app" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
    name = "alb-ingress-controller"
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
    verbs      = ["create", "get", "list", "watch", "update", "patch"]
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "app" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
    name = "alb-ingress-controller"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "alb-ingress-controller"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "admin"
    namespace = "kube-system"
  }
}

data "aws_iam_role" "app" {
  name = "${var.name}-${var.environment}-main-ingress-role"
}

resource "kubernetes_service_account" "app" {
  automount_service_account_token = true
  metadata {
    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
    name      = "alb-ingress-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.app.arn
    }
  }
}

resource "kubernetes_deployment" "ingress" {
  metadata {
    namespace = "kube-system"
    name      = "alb-ingress-controller"
    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
  }

  spec {

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "alb-ingress-controller"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "alb-ingress-controller"
        }
      }

      spec {

        container {
          image = "docker.io/amazon/aws-alb-ingress-controller:v1.1.4"
          name  = "alb-ingress-controller"
          args  = ["--ingress-class=alb", "--cluster-name=${var.name}-${var.environment}", "--aws-vpc-id=${data.aws_vpc.vpc.id}", "--aws-region=${var.region}"]
        }

        service_account_name = "alb-ingress-controller"
      }
    }
  }
}

resource "kubernetes_ingress" "app" {
  metadata {
    namespace = var.namespace
    annotations = {
      //"alb.ingress.kubernetes.io/backend-protocol" = "HTTPS"
      //"alb.ingress.kubernetes.io/certificate-arn"  = "arn:aws:acm:region:client_id:certificate/cert_hash"
      //"alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
      "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\":80}]"
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "kubernetes.io/ingress.class"                = "alb"
    }
    name = "alb-ingress-controller"
  }

  spec {

    backend {
      service_name = var.name
      service_port = 80
    }

    rule {
      host = var.domain
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

