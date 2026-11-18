provider "azurerm" {
  features {}

  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
  resource_providers_to_register  = ["Microsoft.App", "Microsoft.ContainerRegistry", "Microsoft.ManagedIdentity", "Microsoft.OperationalInsights"]
}
