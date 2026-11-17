resource "azurerm_resource_group" "main" {
  name     = "rg-test-2-prod"
  location = var.location
  tags     = local.common_tags
}
