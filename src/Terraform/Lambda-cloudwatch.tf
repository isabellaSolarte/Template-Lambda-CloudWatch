
provider "aws" {
  region = "us-east-1"
}
locals {
  function_name             = "${{ values.function_name }}"
  name_event                = "${{ values.name_event }}"
  schedule_expression_event = "${{ values.schedule_expression_event }}"
  description_rule_event    = "${{ values.description_rule_event }}"
  runtime                   = "${{ values.runtime }}"
  memory_size               = tonumber("${{ values.memory_size }}")
  timeout                   = tonumber("${{ values.timeout }}")
}

# 1. REGLA DE EVENTO CLOUDWATCH
resource "aws_cloudwatch_event_rule" "cron_rule" {
  name                = locals.name_event
  description         = locals.description_rule_event
  schedule_expression = locals.schedule_expression_event

  tags = {
    ManagedBy = "Backstage-Terraform"
    Project   = locals.function_name
  }
}

# 2. VINCULACIÓN OBJETIVO (TARGET)
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.cron_rule.name
  target_id = "TargetLambda"
  arn       = aws_lambda_function.aws_lambda.arn
}

# 3. RECURSO AWS LAMBDA
resource "aws_lambda_function" "aws_lambda" {
  function_name    = locals.function_name
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "index.handler"
  runtime          = locals.runtime
  memory_size      = locals.memory_size
  timeout          = locals.timeout
  filename         = "lambda_code.zip"

  tags = {
    ManagedBy = "Backstage-Terraform"
  }
}

# 4. ROL DE SEGURIDAD IAM
resource "aws_iam_role" "lambda_exec_role" {
  name = "${locals.function_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# 5. PERMISO DE INVOCACIÓN DESDE CLOUDWATCH
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron_rule.arn
}