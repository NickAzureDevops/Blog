resource "azurerm_resource_group" "rg" {
  name     = "regional-lb-demo-${var.regions.region1.location}"
  location = var.regions.region1.location
}
resource "azurerm_resource_group" "rg_2" {
  for_each = var.regions
  name     = "regional-lb-demo1-${each.value.location}"
  location = each.value.location
}