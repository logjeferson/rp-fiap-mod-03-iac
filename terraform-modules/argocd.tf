resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.4.4"

  set = [
    {
      name  = "server.ingress.enabled"
      value = "true"
    },
    {
      name  = "server.ingress.ingressClassName"
      value = "nginx"
    },
    {
      name  = "server.ingress.hosts[0]"
      value = "argocd.mysandbox.com.br"
    },
    {
      name  = "server.ingress.https"
      value = "true"
    },
    {
      name  = "server.extraArgs[0]"
      value = "--insecure"
    }
  ]
}