variable "location" {
  type        = string
  description = "location of resoure"
}
variable "environment" {
  type = string
}
variable "appservice" {
  type        = list(string)
  description = "appservice name"
  default     = ["frontend", "backend"]
}
variable "app_plan" {
  type = map(object({
    name     = string
    os_type  = string
    sku_name = string
  }))
}

variable "app_plan_autoscale" {
  type = map(object({
    name             = string
    target_resource  = string
    metric_resource  = string
    enable_autoscale = bool
  }))
}
variable "profile_recurrence_days" {
  type        = list(any)
  description = "profile recurrence days "
}

variable "autoscale_rule" {
  type = list(object({
    metric_name      = string
    time_grain       = string
    statistic        = string
    time_window      = string
    time_aggregation = string
    operator         = string
    threshold        = number

    direction = string
    type      = string
    value     = number
    cooldown  = string
  }))
}
variable "autoscale_recurrence" {
  type = map(object({
    timezone = string
    days     = list(string)
    hours    = any
    minutes  = any
  }))
}

