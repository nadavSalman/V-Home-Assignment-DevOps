# Rendering the template file
data "template_file" "prep_deployment" {
  template = file("${path.module}/templets/prep_deployment.tftpl")

  vars = {
    subscription_id      = var.subscription_id
    aks_name             = var.aks_name
    aks_rg_name          = var.aks_rg_name
    acr_name             = var.acr_name
    storage_account_name = var.storage_account_name
    container_name       = var.container_name
  }
}



resource "local_file" "foo" {
  content = templatefile("${path.module}/templates/prep_deployment.tftpl",
    {
      subscription_id      = var.subscription_id
      aks_name             = var.aks_name
      aks_rg_name          = var.aks_rg_name
      acr_name             = var.acr_name
      storage_account_name = var.storage_account_name
      container_name       = var.container_name
    }
  )
  filename = "${path.module}/prep_deployment.yaml"
}

# Output the rendered template
output "prep_deployment" {
  value = data.template_file.prep_deployment.rendered
}