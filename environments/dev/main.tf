


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



