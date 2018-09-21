provider "kubernetes" {
  host                   = "${var.kubernetes_ip}"
  config_context_cluster = "mycluster.icp"
  token                  = "${var.k8s_token}"
  insecure               = "true"
}

resource "kubernetes_service" "gitlab-service" {
  metadata {
    name = "${var.name}"
  }

  spec {
    selector {
      app = "${kubernetes_pod.gitlab.metadata.0.labels.app}"
    }

    port {
      port        = 8080
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_pod" "gitlab" {
  metadata {
    name = "${var.name}"

    labels {
      app = "gitlab"
    }
  }

  spec {
    container {
      image = "gitlab/gitlab-ce:latest"
      name  = "example"

      port {
        container_port = 80

        # host_port      = 8080
      }
    }

    # host_network = "localhost:8080"
  }
}
