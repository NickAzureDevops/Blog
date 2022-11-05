terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.14.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-prd01"
    storage_account_name = "saterraformdevops"
    container_name       = "tfstate"
    key                  = "autoscale.tfstate"
  }
}