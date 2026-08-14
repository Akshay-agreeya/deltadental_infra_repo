variable "three_tier_apps" {
  description = "Map of 3-tier application configurations"
  type = map(object({
    resource_group_name = string
    location            = string
    vnet_address_space  = string
    web_subnet_prefix   = string
    app_subnet_prefix   = string
    data_subnet_prefix  = string
    web_sku_name        = string
    app_sku_name        = string
    sql_admin_login     = string
    sql_admin_password  = string
    sql_database_name   = string
    sql_sku_name        = string
    tags                = map(string)
  }))
}
