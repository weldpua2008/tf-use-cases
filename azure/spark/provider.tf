terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
   backend "azurerm" {
        resource_group_name  = "tfstate"
        storage_account_name = "tfeastus2tfusecase"
        container_name       = "tstate"
        key                  = "prod.terraform.tfstate"
    }
}

# Storage for backend
resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.location
  tags = var.tags
}

resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/.kube/config_zure_k8s"
  }
}
