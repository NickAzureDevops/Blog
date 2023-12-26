terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.48.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }
  experiments = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "saterraformdevops"
    container_name       = "devtfstate"
    key                  = "terraform.tfstate"
  }
}