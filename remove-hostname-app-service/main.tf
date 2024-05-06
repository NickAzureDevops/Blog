resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
}

resource "azurerm_service_plan" "plan" {
  name                = format("plan-hostname-example-%s", var.location)
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "app_service" {
  name                = format("app-service-hostname-example-%s", var.location)
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {}
}


output "simplified_hostname" {
  value = replace(azurerm_linux_web_app.app_service.default_hostname, ".azurewebsites.net", "test.webapp.com")
}
