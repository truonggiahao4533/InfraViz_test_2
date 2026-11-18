terraform {
  required_version = ">= 1.16"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.12.0"
    }
  }

  backend "azurerm" {
    key              = "dev.tfstate"
    use_azuread_auth = true
  }
}
