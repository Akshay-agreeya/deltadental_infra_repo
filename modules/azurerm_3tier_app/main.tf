# ── Networking ────────────────────────────────────────────────────────────────

resource "azurerm_virtual_network" "vnet" {
  for_each            = var.three_tier_apps
  name                = "${each.key}-vnet"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = [each.value.vnet_address_space]
  tags                = each.value.tags
}

# Tier-1 (Web) subnet – delegated to App Service VNet integration
resource "azurerm_subnet" "web" {
  for_each             = var.three_tier_apps
  name                 = "snet-web"
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes     = [each.value.web_subnet_prefix]

  delegation {
    name = "app-service-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Tier-2 (App / API) subnet – delegated to App Service VNet integration
resource "azurerm_subnet" "app" {
  for_each             = var.three_tier_apps
  name                 = "snet-app"
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes     = [each.value.app_subnet_prefix]

  delegation {
    name = "app-service-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Tier-3 (Data) subnet – used for SQL private endpoint
resource "azurerm_subnet" "data" {
  for_each                          = var.three_tier_apps
  name                              = "snet-data"
  resource_group_name               = each.value.resource_group_name
  virtual_network_name              = azurerm_virtual_network.vnet[each.key].name
  address_prefixes                  = [each.value.data_subnet_prefix]
  private_endpoint_network_policies = "Disabled"
}

# ── Tier-1: Presentation (Web App) ────────────────────────────────────────────

resource "azurerm_service_plan" "web" {
  for_each            = var.three_tier_apps
  name                = "${each.key}-web-plan"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  os_type             = "Linux"
  sku_name            = each.value.web_sku_name
  tags                = each.value.tags
}

resource "azurerm_linux_web_app" "web" {
  for_each                  = var.three_tier_apps
  name                      = "${each.key}-web"
  location                  = each.value.location
  resource_group_name       = each.value.resource_group_name
  service_plan_id           = azurerm_service_plan.web[each.key].id
  virtual_network_subnet_id = azurerm_subnet.web[each.key].id
  tags                      = each.value.tags

  site_config {
    always_on = true
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    API_URL = "https://${each.key}-app.azurewebsites.net"
  }
}

# ── Tier-2: Application (API App) ─────────────────────────────────────────────

resource "azurerm_service_plan" "app" {
  for_each            = var.three_tier_apps
  name                = "${each.key}-app-plan"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  os_type             = "Linux"
  sku_name            = each.value.app_sku_name
  tags                = each.value.tags
}

resource "azurerm_linux_web_app" "app" {
  for_each                  = var.three_tier_apps
  name                      = "${each.key}-app"
  location                  = each.value.location
  resource_group_name       = each.value.resource_group_name
  service_plan_id           = azurerm_service_plan.app[each.key].id
  virtual_network_subnet_id = azurerm_subnet.app[each.key].id
  tags                      = each.value.tags

  site_config {
    always_on = true
    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    DB_CONNECTION_STRING = "Driver={ODBC Driver 17 for SQL Server};Server=tcp:${each.key}-sqlsrv.database.windows.net,1433;Database=${each.value.sql_database_name};Uid=${each.value.sql_admin_login};******;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
  }
}

# ── Tier-3: Data (SQL Server + Database) ──────────────────────────────────────

resource "azurerm_mssql_server" "sql" {
  for_each                     = var.three_tier_apps
  name                         = "${each.key}-sqlsrv"
  location                     = each.value.location
  resource_group_name          = each.value.resource_group_name
  version                      = "12.0"
  administrator_login          = each.value.sql_admin_login
  administrator_login_password = each.value.sql_admin_password
  tags                         = each.value.tags
}

resource "azurerm_mssql_database" "db" {
  for_each  = var.three_tier_apps
  name      = each.value.sql_database_name
  server_id = azurerm_mssql_server.sql[each.key].id
  sku_name  = each.value.sql_sku_name
  tags      = each.value.tags
}

# ── Private Endpoint + DNS for SQL ────────────────────────────────────────────

resource "azurerm_private_endpoint" "sql" {
  for_each            = var.three_tier_apps
  name                = "${each.key}-sql-pe"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id           = azurerm_subnet.data[each.key].id
  tags                = each.value.tags

  private_service_connection {
    name                           = "${each.key}-sql-psc"
    private_connection_resource_id = azurerm_mssql_server.sql[each.key].id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "sql" {
  for_each            = var.three_tier_apps
  name                = "privatelink.database.windows.net"
  resource_group_name = each.value.resource_group_name
  tags                = each.value.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  for_each              = var.three_tier_apps
  name                  = "${each.key}-sql-dns-link"
  resource_group_name   = each.value.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql[each.key].name
  virtual_network_id    = azurerm_virtual_network.vnet[each.key].id
  tags                  = each.value.tags
}

resource "azurerm_private_dns_a_record" "sql" {
  for_each            = var.three_tier_apps
  name                = "${each.key}-sqlsrv"
  zone_name           = azurerm_private_dns_zone.sql[each.key].name
  resource_group_name = each.value.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql[each.key].private_service_connection[0].private_ip_address]
  tags                = each.value.tags
}
