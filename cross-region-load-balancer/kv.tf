resource "random_id" "random" {
  byte_length = 6
  prefix      = "kv"
}

data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv" {
  name                        = format("kv-lb-%s-001", var.regions.region1.location)
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "random_password" "vmpassword" {
  length  = 20
  special = true
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name            = "vmpassword"
  value           = random_password.vmpassword.result
  key_vault_id    = azurerm_key_vault.kv.id
  expiration_date = timeadd(timestamp(), "8760h")
  content_type    = "Password"
}