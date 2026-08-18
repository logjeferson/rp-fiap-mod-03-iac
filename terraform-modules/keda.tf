resource "helm_release" "keda" {
  name             = "keda"
  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  namespace        = "keda"
  create_namespace = true
  version          = "2.14.3"
  values = [
    yamlencode({
      serviceAccount = {
        operator = {
          annotations = {
            "eks.amazonaws.com/role-arn" = module.sqs_queue.keda_sqs_role_arn
          }
        }
        metricServer = {
          annotations = {
            "eks.amazonaws.com/role-arn" = module.sqs_queue.keda_sqs_role_arn
          }
        }
      }
    })
  ]
}