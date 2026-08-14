terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.70.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id                 = "20cadb7c-62d8-4c57-9b49-63ebd307c63e"
  resource_provider_registrations = "none"
}