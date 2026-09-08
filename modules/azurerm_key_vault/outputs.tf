output "key_vault_ids" {
  description = "IDs of the created Azure Key Vaults."
  value       = { for key, vault in azurerm_key_vault.vaults : key => vault.id }
}

output "key_vault_uris" {
  description = "Vault URIs of the created Azure Key Vaults."
  value       = { for key, vault in azurerm_key_vault.vaults : key => vault.vault_uri }
}
