variable "rg_name" {
  description = "Name of the resource group"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-z-]+$", var.rg_name))
    error_message = "The resource group name must contain only lowercase letters (a-z) and hyphens (-)."
  }
}

variable "name" {
  type        = string
  description = "Location of the azure resource group."
  default     = "varonis"
}

variable "environment" {
  type        = string
  description = "Name of the deployment environment"
  default     = "prd"
}


variable "location" {
  type        = string
  description = "Location of the azure resource group."
  default     = "WestUS2"
}

variable "node_count" {
  type        = number
  description = "The number of K8S nodes to provision."
  default     = 3
}

variable "node_type" {
  type        = string
  description = "The size of each node."
  default     = "Standard_D2s_v3"
}

variable "dns_prefix" {
  type        = string
  description = "DNS Prefix"
  default     = "tfq"
}


variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}