resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "eks-argocd-namespace"
  create_namespace = true
  version          = "7.4.4"

  values = [
    yamlencode({
      server = {
        ingress = {
          enabled          = true
          ingressClassName = "nginx"
          hosts            = ["argocd.mysandbox.com.br"]
          https            = true
        }
        extraArgs = ["--insecure"]
      }
    })
  ]
}