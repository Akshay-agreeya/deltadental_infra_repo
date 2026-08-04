


dev_acrs = {
  acr1 = {
    acr_name            = "devtodoacrwestus"
    resource_group_name = "psddg"
    location            = "westus 2"
    sku                 = "Standard"
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
  }
}








