


module "acr" {
  
  source     = "../../modules/azurerm_acr"
  acrs       = var.dev_acrs
}

module "aks" {
  depends_on = [module.acr]
  source     = "../../modules/azurerm_aks"
  aks_var    = var.dev_aks
}

module "database" {
  depends_on  = [module.acr]
  source      = "../../modules/azurerm_Database"
  servers_dbs = var.servers_dbs
}

module "key_vault" {
  source     = "../../modules/azurerm_key_vault"
  key_vaults = var.dev_key_vaults
}
