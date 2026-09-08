data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vaults" {
  for_each = var.key_vaults

  name                          = each.value.key_vault_name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = each.value.sku_name
  soft_delete_retention_days    = each.value.soft_delete_retention_days
  purge_protection_enabled      = each.value.purge_protection_enabled
  enable_rbac_authorization     = true
  public_network_access_enabled = each.value.public_network_access_enabled
  tags                          = each.value.tags
}
