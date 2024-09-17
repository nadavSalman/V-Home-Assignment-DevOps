resource "helm_release" "external_nginx" {
  name = "nginx-ingress-controller-external"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  create_namespace = true
  version          = "4.8.0"

  values = [file("${path.module}/nginx-ingress-controller-values/ingress.yaml")]
}