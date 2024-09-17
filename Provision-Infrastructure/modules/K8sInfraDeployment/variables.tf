variable "aks_host" {
  type        = string
  description = "The AKS cluster host URL."
}

variable "aks_client_certificate" {
  type        = string
  description = "The base64 decoded client certificate for the AKS cluster."
}

variable "aks_client_key" {
  type        = string
  description = "The base64 decoded client key for the AKS cluster."
}

variable "aks_cluster_ca_certificate" {
  type        = string
  description = "The base64 decoded cluster CA certificate for the AKS cluster."
}


variable "aks_resource_group" {
  type    = string
  default = ""
}

variable "aks_cluster_name" {
  type    = string
  default = ""
}
