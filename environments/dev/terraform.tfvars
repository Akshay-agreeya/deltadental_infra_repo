


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

three_tier_apps = {
  devtodo3tier = {
    resource_group_name = "psddg"
    location            = "westus 2"
    vnet_address_space  = "10.0.0.0/16"
    web_subnet_prefix   = "10.0.1.0/24"
    app_subnet_prefix   = "10.0.2.0/24"
    data_subnet_prefix  = "10.0.3.0/24"
    web_sku_name        = "B1"
    app_sku_name        = "B1"
    sql_admin_login     = "devopsadmin"
    sql_admin_password  = "P@ssw01rd@123"
    sql_database_name   = "todoappdb3tier"
    sql_sku_name        = "S1"
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








