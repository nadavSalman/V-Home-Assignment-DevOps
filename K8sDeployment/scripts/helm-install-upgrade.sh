


helm upgrade --install restaurants-app ./RestaurantApp/helm/restaurants-app \
  -f ../../Provision-Infrastructure/modules/DeploymentPrep/prep_deployment.yaml \
  --set image.tag="${{ env.IMAGE_TAG }}"
