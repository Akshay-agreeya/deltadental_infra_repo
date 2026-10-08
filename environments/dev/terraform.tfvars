


dev_acrs = {
  acr1 = {
    acr_name            = "devtodoacrwestus"
    resource_group_name = "psddg"
    location            = "westus 2"
    sku                 = "Standard"
    tags = {
      environment = "development"
      project     = "todoapp"
      managed_by  = "terraform"
    }
  }
}

dev_aks = {
  aks1 = {
    aks_name            = "devtodoakswestus"
    resource_group_name = "psddg"
    location            = "westus 2"
    dns_prefix          = "devtodoaks"
    node_count          = 1
    vm_size             = "Standard_DS2_V2"
    tags = {
      environment = "development"
      project     = "todoapp"
      managed_by  = "terraform"
    }
  }

}

servers_dbs = {
  "devtododbsrvwuswus1" = {
    resource_group_name            = "psddg"
    location                       = "westus 2"
    version                        = "12.0"
    administrator_login            = "devopsadmin"
    administrator_login_password   = "P@ssw01rd@123"
    allow_access_to_azure_services = true
    dbs                            = ["todoappdb"]
    tags = {
      environment = "development"
      project     = "todoapp"
      managed_by  = "terraform"
    }
  }
}

dev_key_vaults = {
  key_vault = {
    key_vault_name                = "devtodokvwestus2"
    resource_group_name           = "psddg"
    location                      = "westus2"
    sku_name                      = "standard"
    soft_delete_retention_days    = 90
    purge_protection_enabled      = true
    public_network_access_enabled = true
    tags = {
      environment = "development"
      project     = "todoapp"
      managed_by  = "terraform"
    }
  }
}





