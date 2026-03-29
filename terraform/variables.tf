variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "canadacentral"
}

variable "project_name" {
  description = "Short name used to prefix all resources"
  type        = string
  default     = "devsecops"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Basic"
}
