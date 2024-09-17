resource "random_integer" "this" {
  min = 10000
  max = 5000000
}

resource "azurerm_storage_account" "backend_system" {
  name                     = "devtest${random_integer.this.result}"
  resource_group_name      = azurerm_resource_group.k8s_rg.name
  location                 = azurerm_resource_group.k8s_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "restaurants_req_res_history" {
  name                  = "restaurants"
  storage_account_name  = azurerm_storage_account.backend_system.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "default" {
  scope                = azurerm_storage_account.backend_system.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.backend_storage_system.principal_id
}