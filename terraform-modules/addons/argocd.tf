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
          annotations = {
            "cert-manager.io/cluster-issuer"                 = "letsencrypt-prod"
            "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
          }
          hosts = [
            var.eks_argocd_domain_name
          ]
          tls = [
            {
              hosts = [
                var.eks_argocd_domain_name
              ]
              secretName = "argocd-tls-cert"
            }
          ]
        }
      }
    })
  ]
}