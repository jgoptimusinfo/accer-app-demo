# Configure the Microsoft Azure Backend block
terraform {
  required_version = ">= 1.9.3"

  backend "azurerm" {
    resource_group_name  = "state-dev"
    storage_account_name = "statedevjg3456"
    container_name       = "accern-tfstate"
    key                  = "terraform-firewall.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.106.1, < 4.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.2"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.51.0"
    }

    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.4.0, < 2.0"
    }

    time = {
      source  = "hashicorp/time"
      version = ">= 0.11.2"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3.4"
    }

    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {

}