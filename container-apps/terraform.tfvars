location      = "uksouth"
revision_mode = "Single"
environment   = "dev"

container_apps = [{

  name    = "hello-k8s-node"
  image   = "dapriosamples/hello-k8s-node:latest"
  cpu     = 0.5
  memory  = "1Gi"

  min_replicas    = 1
  max_replicas    = 1
  revision_suffix = "blue"
}]

ingress = [{
  allow_insecure_connections = false
  external_enabled           = false
  target_port                = 1
  transport                  = "http"
  label                      = "v"
  latest_revision            = true
  percentage                 = 100
  revision_suffix            = "blue"
}]

# container_min_replicas    = 1
# container_max_replicas    = 1
# container_revision_suffix = "v1"
