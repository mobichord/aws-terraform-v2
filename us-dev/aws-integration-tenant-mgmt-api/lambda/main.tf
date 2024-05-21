resource "aws_iam_role" "aws_integration_tenant_mgmt_function_role" {
  name = "${var.prefix_name}-function-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
  ]
}

resource "aws_lambda_function" "aws_integration_tenant_mgmt_function" {
  function_name    = var.lambda_function_name
  description      = "Lambda function that creates tenant from oregon to frankfurt and vice versa."
  handler          = "app.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60
  role             = aws_iam_role.aws_integration_tenant_mgmt_function_role.arn
  filename         = "${path.module}/code/${var.lambda_function_name}.zip"

  environment {
    variables = {
      MONGODB_DOMAIN: var.mongodb_domain
      MONGODB_URI: var.mongodb_url
      MONGODB_NAME: var.mongodb_name
      ENV_SECRET: var.env_secret
      OREGON_DEV: var.us_dev_domain
      OREGON_STAGING: var.us_stage_domain
      OREGON_PROD: var.us_prod_domain
      FRANKFURT_STAGING: var.eu_stage_domain
      FRANKFURT_PROD: var.eu_prod_domain
      OREGON_DEV_USR: var.us_dev_usr
      OREGON_DEV_PWD: var.us_dev_pwd
      OREGON_STAGING_USR: var.us_staging_usr
      OREGON_STAGING_PWD: var.us_staging_pwd
      OREGON_PROD_USR: var.us_prod_usr
      OREGON_PROD_PWD: var.us_prod_pwd
      FRANKFURT_STAGING_USR: var.eu_staging_usr
      FRANKFURT_STAGING_PWD: var.eu_staging_pwd
      FRANKFURT_PROD_USR: var.eu_prod_usr
      FRANKFURT_PROD_PWD: var.eu_prod_pwd
      COLLECTION_NAME: var.collection_name
      API_ENDPOINT: var.api_endpoint
    }
  }

  tags = {
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
    Project     = var.project_tag
  }

  vpc_config {
    security_group_ids = [
      var.aws_backend_security_group2_id
    ]
    subnet_ids = [
      var.aws_backend_private_subnet1_id,
      var.aws_backend_private_subnet2_id
    ]
  }
}

resource "aws_cloudwatch_log_group" "aws_integration_tenant_mgmt_function_log_group" {
  name = "/aws/lambda/${aws_lambda_function.aws_integration_tenant_mgmt_function.function_name}"
}

resource "aws_lambda_permission" "aws_integration_tenant_mgmt_function_invoke_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_integration_tenant_mgmt_function.arn
  principal     = "apigateway.amazonaws.com"
}