variable "location" {
  type        = string
  description = "The Azure Region where all resources in this example should be created."
}
variable "environment" {
  type        = string
  description = "The environment name to use for all resources in this example."
}
variable "revision_mode" {
  type        = string
  description = "The revision mode to use for the container app."
}
variable "container_apps" {
  description = "(Optional) Specifies the container apps."
  type = list(object({
    name    = string
    image   = string
    args    = optional(list(string))
    command = optional(list(string))
    cpu     = optional(string)
    memory  = optional(string)
  }))
}
variable "ingress" {
  description = "(Optional) Specifies the ingress."
  type = list(object({
    allow_insecure_connections = bool
    external_enabled           = bool
    target_port                = number
    transport                  = string
    label                      = string
    latest_revision            = bool
    revision_suffix            = string
    percentage                 = number
  }))
}
variable "container_min_replicas" {
  type        = number
  description = "The minimum number of replicas for the container app."
  default     = 1
}

variable "container_max_replicas" {
  type        = number
  description = "The maximum number of replicas for the container app."
  default     = 1
}

variable "container_revision_suffix" {
  type        = string
  description = "The revision suffix for the container app."
  default     = "blue"
}
