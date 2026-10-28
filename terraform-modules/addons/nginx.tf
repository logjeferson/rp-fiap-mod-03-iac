resource "helm_release" "ingress_nginx" {
  depends_on       = [helm_release.kube_prometheus_stack]
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "eks-namespace"
  create_namespace = true
  version          = "4.10.1"
  values = [
    yamlencode({
      controller = {
        service = {
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
          }
        }
        metrics = {
          enabled = true
          serviceMonitor = {
            enabled = true
            additionalLabels = {
              release = "kube-prometheus-stack"
            }
          }
        }
      }
    })
  ]
}