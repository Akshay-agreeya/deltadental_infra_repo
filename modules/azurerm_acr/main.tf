resource "azurerm_container_registry" "acr" {
    for_each = var.acrs
    name = each.value.acr_name
    resource_group_name = each.value.resource_group_name
    location = each.value.location
    sku = each.value.sku
    admin_enabled = false
}




