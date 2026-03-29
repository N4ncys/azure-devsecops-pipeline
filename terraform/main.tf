# ── Data sources ──────────────────────────────────────────────
data "azurerm_client_config" "current" {}

# ── Resource Group ────────────────────────────────────────────
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location

  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

# ── Log Analytics Workspace ───────────────────────────────────
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = azurerm_resource_group.main.tags
}

# ── Azure Container Registry ──────────────────────────────────
resource "azurerm_container_registry" "main" {
  name                = "acrdevsecops5${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.acr_sku
  admin_enabled       = false


  trust_policy {
    enabled = false
  }


  tags = azurerm_resource_group.main.tags
}

# ── User-Assigned Managed Identity ───────────────────────────
resource "azurerm_user_assigned_identity" "pipeline" {
  name                = "id-${var.project_name}-pipeline"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = azurerm_resource_group.main.tags
}

# ── Role Assignment: Identity can push/pull from ACR ─────────
resource "azurerm_role_assignment" "pipeline_acr_push" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.pipeline.principal_id
}

# ── Key Vault ─────────────────────────────────────────────────
resource "azurerm_key_vault" "main" {
  name                       = "kv-${var.project_name}-5-${var.environment}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = []
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.pipeline.principal_id

    secret_permissions = [
      "Get", "List"
    ]
  }

  tags = azurerm_resource_group.main.tags
}

# ── Container Apps Environment ────────────────────────────────
resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${var.project_name}-${var.environment}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  tags = azurerm_resource_group.main.tags
}
