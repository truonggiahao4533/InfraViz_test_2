output "container_app_main_2_url" {
  description = "Public URL of azurerm_container_app.main_2."
  value       = "https://${azurerm_container_app.main_2.ingress[0].fqdn}"
}

output "container_registry_main_login_server" {
  description = "Login server of azurerm_container_registry.main, for pushing images."
  value       = azurerm_container_registry.main.login_server
}
