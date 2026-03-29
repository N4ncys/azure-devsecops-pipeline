output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = azurerm_container_registry.main.login_server
}

output "acr_name" {
  description = "ACR resource name"
  value       = azurerm_container_registry.main.name
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.main.vault_uri
}

output "managed_identity_client_id" {
  description = "Client ID of the pipeline managed identity"
  value       = azurerm_user_assigned_identity.pipeline.client_id
}

output "managed_identity_principal_id" {
  description = "Principal ID of the pipeline managed identity"
  value       = azurerm_user_assigned_identity.pipeline.principal_id
}

output "container_app_environment_id" {
  description = "Container Apps Environment ID"
  value       = azurerm_container_app_environment.main.id
}
