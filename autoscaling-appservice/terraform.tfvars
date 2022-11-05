environment = "dev"
location    = "uksouth"

app_plan = {
  frontend = {
    name     = "frontend"
    os_type  = "Linux"
    sku_name = "S1"
  },
  backend = {
    name     = "backend"
    os_type  = "Linux"
    sku_name = "S1"
  }
}

app_plan_autoscale = {
  frontend_app = {
    name             = "frontendAutoscaleSetting"
    target_resource  = "frontend"
    metric_resource  = "frontend"
    enable_autoscale = true
  },
  backend_app = {
    name             = "backendAutoscaleSetting"
    target_resource  = "backend"
    metric_resource  = "backend"
    enable_autoscale = true
  },
}

profile_recurrence_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

autoscale_rule = [
  {
    metric_name      = "CpuPercentage"
    time_grain       = "PT1M"
    statistic        = "Average"
    time_window      = "PT5M"
    time_aggregation = "Average"
    operator         = "GreaterThan"
    threshold        = 90

    direction = "Increase"
    type      = "ChangeCount"
    value     = "1"
    cooldown  = "PT1M"
  },
  {
    metric_name      = "MemoryPercentage"
    time_grain       = "PT1M"
    statistic        = "Average"
    time_window      = "PT5M"
    time_aggregation = "Average"
    operator         = "GreaterThan"
    threshold        = 70

    direction = "Increase"
    type      = "ChangeCount"
    value     = "1"
    cooldown  = "PT1M"
  }
]
autoscale_recurrence = {
  recurrence = {
    timezone = "UTC"
    days     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    hours    = [0]
    minutes  = [0]
  }
}
