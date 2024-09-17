# output-template.tf
data "template_file" "k8s_yaml" {
  template = <<EOF
AzureResources:
  subscriptionID: ${var.subscription_id}
  AKS:
    name: ${var.ask_name}
    ResourceGroup: ${var.aks_rg_name}
  ACR:
    name: ${var.acr_name}
    ResourceGroup: ${var.aks_rg_name}
  backendStorageSystem:
    storageAccountName: ${var.storage_account_name}
    ResourceGroup: ${var.aks_rg_name}
    continerName: ${var.continer_name}
EOF
}

output "yaml_file" {
  value = data.template_file.k8s_yaml.rendered
}