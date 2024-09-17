# Output the rendered template
output "prep_deployment" {
  value = data.template_file.prep_deployment.rendered
}