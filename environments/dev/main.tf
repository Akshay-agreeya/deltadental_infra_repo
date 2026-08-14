


module "acr" {

  source = "../../modules/azurerm_acr"
  acrs   = var.dev_acrs
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

module "three_tier_app" {
  source          = "../../modules/azurerm_3tier_app"
  three_tier_apps = var.three_tier_apps
}



