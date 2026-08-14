output "web_app_urls" {
  description = "Default hostnames for the Tier-1 web App Services"
  value       = { for k, v in azurerm_linux_web_app.web : k => "https://${v.default_hostname}" }
}

output "app_service_urls" {
  description = "Default hostnames for the Tier-2 API App Services"
  value       = { for k, v in azurerm_linux_web_app.app : k => "https://${v.default_hostname}" }
}

output "sql_server_fqdns" {
  description = "Fully-qualified domain names for the SQL servers"
  value       = { for k, v in azurerm_mssql_server.sql : k => v.fully_qualified_domain_name }
}

output "vnet_ids" {
  description = "Resource IDs of the provisioned VNets"
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.id }
}
