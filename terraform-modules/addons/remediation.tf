variable "rds_dbs" {
  description = "Mapa de configurações dos bancos de dados dos microserviços"
  type = map(object({
    identifier = string
    database   = string
  }))
  default = {
    auth      = { identifier = "rds-auth-db-01", database = "auth_db" }
    flag      = { identifier = "rds-flag-db-01", database = "flags_db" }
    targeting = { identifier = "rds-targeting-db-01", database = "targeting_db" }
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "remediation.py"
  output_path = "remediation_payload.zip"
}

resource "aws_iam_role" "lambda_remediation_role" {
  name = "lambda-remediation-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "lambda.amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy" "lambda_rds_policy" {
  name = "lambda-rds-start-policy"
  role = aws_iam_role.lambda_remediation_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["rds:DescribeDBInstances", "rds:StartDBInstance"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_lambda_function" "remediation_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = "sre-rds-remediation"
  role             = aws_iam_role.lambda_remediation_role.arn
  handler          = "remediation.lambda_handler"
  runtime          = "python3.10"
  timeout          = 15
  environment {
    variables = {
      RDS_MAP = jsonencode(var.rds_dbs)
    }
  }
}

resource "aws_lambda_permission" "public_function_url" {
  statement_id           = "AllowPublicInvoke"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.remediation_lambda.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}

resource "aws_lambda_function_url" "remediation_webhook" {
  function_name      = aws_lambda_function.remediation_lambda.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["content-type", "date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_permission" "public_function_url" {
  statement_id           = "AllowPublicInvoke"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.remediation_lambda.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}