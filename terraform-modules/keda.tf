resource "helm_release" "keda" {
  name             = "keda"
  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  namespace        = "eks-keda-namespace"
  create_namespace = true
  version          = "2.14.3"

  set {
    name  = "serviceAccount.operator.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.keda_role.arn
  }

  set {
    name  = "serviceAccount.metricServer.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.keda_role.arn
    
  }
}