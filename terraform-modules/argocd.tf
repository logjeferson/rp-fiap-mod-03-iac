resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argo-cd"
  create_namespace = true
  version          = "7.4.4"
  values = [
    yamlencode({
      server = {
        extraArgs = ["--insecure"]
        ingress = {
          enabled          = true
          ingressClassName = "nginx"
          hosts = [
            "argocd.mysandbox.com.br"
          ]
          tls = [
            {
              hosts = [
                "argocd.mysandbox.com.br"
              ]
              secretName = "argocd-tls-cert"
            }
          ]
        }
      }
    })
  ]
}