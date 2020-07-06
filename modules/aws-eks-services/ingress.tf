
resource "kubernetes_cluster_role" "ingress" {
  metadata {
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
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

resource "kubernetes_cluster_role_binding" "ingress" {
  metadata {
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
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
    name      = "alb-ingress-controller"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_cluster_role.ingress]
}

data "aws_iam_role" "app" {
  name = "${var.cluster}-main-ingress-role"
}

resource "kubernetes_service_account" "ingress" {
  automount_service_account_token = true
  metadata {
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
    name      = "alb-ingress-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.ingress.arn
    }
  }
}

resource "kubernetes_deployment" "ingress" {
  metadata {
    namespace = "kube-system"
    name      = "alb-ingress-controller"
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
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
        name = "alb-ingress-controller"
        labels = {
          "app.kubernetes.io/name"       = "alb-ingress-controller"
          "app.kubernetes.io/managed-by" = "terraform"
        }
      }

      spec {

        container {
          name              = "alb-ingress-controller"
          image_pull_policy = "Always"
          image             = "docker.io/amazon/aws-alb-ingress-controller:v1.1.5"
          args = [
            "--ingress-class=alb",
            "--cluster-name=${var.name}-${var.environment}",
            "--aws-vpc-id=${var.vpc_id}",
            "--aws-region=${var.region}",
            "--aws-max-retries=10"
          ]
          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = kubernetes_service_account.ingress.default_secret_name
            read_only  = true
          }
        }
        dns_policy           = "ClusterFirst"
        restart_policy       = "Always"
        service_account_name = "alb-ingress-controller"

        volume {
          name = kubernetes_service_account.ingress.default_secret_name
          secret {
            secret_name = kubernetes_service_account.ingress.default_secret_name
          }
        }
      }
    }
  }
  depends_on = [kubernetes_service_account.ingress, kubernetes_cluster_role_binding.ingress]
}

