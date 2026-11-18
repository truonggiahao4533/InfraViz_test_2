resource "azurerm_container_app_environment" "main" {
  name                       = "cae-test-2-dev"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags                       = local.common_tags

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}

resource "azurerm_container_app" "main" {
  name                         = "ca-test-2-dev-be"
  resource_group_name          = azurerm_resource_group.main.name
  container_app_environment_id = azurerm_container_app_environment.main.id
  revision_mode                = "Single"
  tags                         = local.common_tags

  template {
    min_replicas = 0
    max_replicas = 3

    container {
      name   = "be"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
      readiness_probe {
        transport = "HTTP"
        port      = 80
      }
      liveness_probe {
        transport = "HTTP"
        port      = 80
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  ingress {
    target_port      = 80
    external_enabled = false
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.identity.id
  }

  depends_on = [azurerm_role_assignment.access]

  lifecycle {
    ignore_changes = [template[0].container[0].image]
  }
}

resource "azurerm_container_app" "main_2" {
  name                         = "ca-test-2-dev-fe"
  resource_group_name          = azurerm_resource_group.main.name
  container_app_environment_id = azurerm_container_app_environment.main.id
  revision_mode                = "Single"
  tags                         = local.common_tags

  template {
    min_replicas = 0
    max_replicas = 3

    container {
      name   = "fe"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "API_URL"
        value = "https://${azurerm_container_app.main.ingress[0].fqdn}"
      }
      readiness_probe {
        transport = "HTTP"
        port      = 80
      }
      liveness_probe {
        transport = "HTTP"
        port      = 80
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }

  ingress {
    target_port                = 80
    external_enabled           = true
    allow_insecure_connections = false
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.main.id
  }

  depends_on = [azurerm_role_assignment.main]

  lifecycle {
    ignore_changes = [template[0].container[0].image]
  }
}

resource "azurerm_container_registry" "main" {
  name                          = "crtest2dev74fe98"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  sku                           = "Basic"
  admin_enabled                 = false
  public_network_access_enabled = true
  tags                          = local.common_tags
}
