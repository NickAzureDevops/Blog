data "azurerm_client_config" "current" {}
resource "azurerm_resource_group" "rg" {
  name     = format("rg-conntainer-demo-%s-%s", var.environment, var.location)
  location = var.location
}
resource "azurerm_container_app_environment" "aca_environment" {
  name                       = format("aca-%s-%s", var.environment, var.location)
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}

resource "azurerm_container_app_environment_dapr_component" "dapr_component" {
  for_each                     = var.container_apps
  name                         = each.key
  container_app_environment_id = azurerm_container_app_environment.aca_environment.id
  component_type               = each.value.component_type
  version                      = each.value.version
  init_timeout                 = each.value.init_timeout
  ignore_errors                = each.value.ignore_errors
  scopes                       = var.dapr_scopes

  #  metadata {
  #     name        = "storageaccountname"
  #     secret_name = "storage_name"
  #     value       = azurerm_storage_account.storage_account.name
  #   }
     secret {
    # for_each = each.value.secret
      name  = "storageaccountkey"
      value = azurerm_storage_account.storage_account.primary_access_key
    }
  }

resource "azurerm_storage_account" "storage_account" {
  name                     = format("sacontainers%s%s", var.environment, var.location)
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"  
}

resource "azurerm_container_app" "container_apps" {
  name                         = format("nodeapp-%s-%s", var.environment, var.location)
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.aca_environment.id
  revision_mode                = var.revision_mode

  template {
    dynamic "container" {
      for_each = var.container_apps
      content {
        name    = container.value.name
        image   = container.value.image
        cpu     = container.value.cpu
        memory  = container.value.memory
      }
    }
    min_replicas    = var.container_min_replicas
    max_replicas    = var.container_max_replicas
    revision_suffix = var.container_revision_suffix
  }

  dynamic "ingress" {
    for_each = var.ingress
    content {
      allow_insecure_connections = ingress.value.allow_insecure_connections
      external_enabled           = ingress.value.external_enabled
      target_port                = ingress.value.target_port
      transport                  = ingress.value.transport

      traffic_weight {
        label           = ingress.value.label
        latest_revision = ingress.value.latest_revision
        revision_suffix = ingress.value.revision_suffix
        percentage      = ingress.value.percentage
      }
    }
  }
}
    # secret {
    #   name  = var.dapr_secret_name
    #   value = azurerm_storage_account.storage_account.primary_access_key
    # }

resource "azapi_update_resource" "containerapp" {
  type        = "Microsoft.App/containerApps@2022-10-01"
  resource_id = azurerm_container_app.container_apps.id

  body = jsonencode({
    properties = {
      configuration = {
        dapr = {
          appPort = null
        }
      }
    }
  })

  depends_on = [
    azurerm_container_app.container_apps
  ]
}