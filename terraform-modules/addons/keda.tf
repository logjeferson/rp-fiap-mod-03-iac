data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    region = var.aws_region
    bucket = var.aws_bucket_iac_name
    key    = var.aws_bucket_iac_folder_name
  }
}

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
            "eks.amazonaws.com/role-arn" = data.terraform_remote_state.infrastructure.outputs.keda_sqs_role_arn
          }
        }
        metricServer = {
          annotations = {
            "eks.amazonaws.com/role-arn" = data.terraform_remote_state.infrastructure.outputs.keda_sqs_role_arn
          }
        }
      }
    })
  ]
}