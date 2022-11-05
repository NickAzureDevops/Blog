# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = format("rg-%s-autoscale", var.environment)
  location = var.location
}

# App service plan 
resource "azurerm_service_plan" "app_plan" {
  for_each            = var.app_plan
  name                = format("plan-%s-%s-autoscale", each.value.name, var.environment)
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  os_type             = each.value.os_type
  sku_name            = each.value.sku_name
}
# Linux web apps 
resource "azurerm_linux_web_app" "app_service" {
  for_each            = toset(var.appservice)
  name                = format("app-%s-autoascale", each.key)
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.app_plan[each.value].id
  https_only          = "true"
  site_config {
  }
}

# Create autoscale profile for App Service Plan
resource "azurerm_monitor_autoscale_setting" "app_service_autoscale" {
  for_each            = var.app_plan_autoscale
  name                = "${var.environment}-${each.value.name}-autoscale"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  target_resource_id  = azurerm_service_plan.app_plan[each.value.target_resource].id
  enabled             = each.value.enable_autoscale

  profile {
    name = "trough-scaling"

    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }
    recurrence {
      timezone = "UTC"
      days     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
      hours    = [0]
      minutes  = [0]
    }
  }
  profile {
    name = "performance-scaling"

    capacity {
      default = 1
      minimum = 1
      maximum = 2
    }

    dynamic "rule" {
      for_each = var.autoscale_rule
      content {

        metric_trigger {
          metric_name        = rule.value.metric_name
          metric_resource_id = azurerm_service_plan.app_plan[each.value.metric_resource].id
          time_grain         = rule.value.time_grain
          statistic          = rule.value.statistic
          time_window        = rule.value.time_window
          time_aggregation   = rule.value.time_aggregation
          operator           = rule.value.operator
          threshold          = rule.value.threshold
        }
        scale_action {

          direction = rule.value.direction
          type      = rule.value.type
          value     = rule.value.value
          cooldown  = rule.value.cooldown
        }
      }
    }
    dynamic "recurrence" {
      for_each = var.autoscale_recurrence
      content {
        timezone = recurrence.value.timezone
        days     = recurrence.value.days
        hours    = recurrence.value.hours
        minutes  = recurrence.value.minutes
      }
    }
  }
  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["test@gmail.com"]
    }
  }
}