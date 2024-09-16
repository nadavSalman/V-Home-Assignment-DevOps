variable "rg-name" {
  description = "Name of the resource group"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-z-]+$", var.rg-name))
    error_message = "The resource group name must contain only lowercase letters (a-z) and hyphens (-)."
  }
}