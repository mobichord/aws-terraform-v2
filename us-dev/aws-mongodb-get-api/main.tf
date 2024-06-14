terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    profile        = "terraform-aws-platform"
    bucket         = "aws-platform-terraform-statefile"
    key            = "aws-mongodb-get-api/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "aws-mongodb-get-api-dev"
  }
}

provider "aws" {
  region     = var.aws_region
  profile = var.aws_profile
  assume_role {
    role_arn = var.aws_role_arn
    session_name = var.aws_session_role
  }
}


# provider "aws" {
#   region     = var.aws_region
#   access_key = var.aws_access_key
#   secret_key = var.aws_secret_key
# }

# provider "github" {
#   token = var.github_token
# }

data "terraform_remote_state" "modules" {
  backend = "s3"

  config = {
    profile = "terraform-aws-platform"
    bucket  = "aws-platform-terraform-statefile"
    key     = "modules/terraform.tfstate"
    region  = "us-west-2"
    dynamodb_table = "aws-platform-terraform-lockstate"
  }
}

module "lambda" {
  source                         = "github.com/mobichord/aws-terraform-v2/us-dev/aws-mongodb-get-api/lambda"
  prefix_name                    = var.prefix_name
  environment_tag                = var.environment_tag
  project_tag                    = var.project_tag
  stage_name                     = var.stage_name
  path_part                      = var.path_part
  mongodb_url                    = var.mongodb_url
  mongodb_name                   = var.mongodb_name
  aws_backend_private_subnet1_id = data.terraform_remote_state.modules.outputs.aws_backend_private_subnet1_id
  aws_backend_private_subnet2_id = data.terraform_remote_state.modules.outputs.aws_backend_private_subnet2_id
  aws_backend_security_group2_id = data.terraform_remote_state.modules.outputs.aws_backend_security_group2_id
}

module "api_gateway" {
  source                             = "github.com/mobichord/aws-terraform-v2/us-dev/aws-mongodb-get-api/api_gateway"
  prefix_name                        = var.prefix_name
  environment_tag                    = var.environment_tag
  project_tag                        = var.project_tag
  stage_name                         = var.stage_name
  path_part                          = var.path_part
  aws_mongodb_ga_function_invoke_arn = module.lambda.aws_mongodb_ga_function_invoke_arn
  aws_backend_vpc_endpoint_id        = data.terraform_remote_state.modules.outputs.aws_backend_vpc_endpoint_id
}

module "budgets" {
  source                          = "github.com/mobichord/aws-terraform-v2/us-dev/aws-mongodb-get-api/budgets"
  prefix_name                     = var.prefix_name
  environment_tag                 = var.environment_tag
  project_tag                     = var.project_tag
  budget_alert_topic_arn          = data.terraform_remote_state.modules.outputs.budget_alert_topic_arn
  lambda_budget_limit_amount      = var.lambda_budget_limit_amount
  lambda_budget_time_unit         = var.lambda_budget_time_unit
  api_gateway_budget_limit_amount = var.api_gateway_budget_limit_amount
  api_gateway_budget_time_unit    = var.api_gateway_budget_time_unit
}

module "cloudwatch" {
  source                     = "github.com/mobichord/aws-terraform-v2/us-dev/aws-mongodb-get-api/cloudwatch"
  prefix_name                = var.prefix_name
  environment_tag            = var.environment_tag
  project_tag                = var.project_tag
  cloudwatch_alarm_topic_arn = data.terraform_remote_state.modules.outputs.cloudwatch_alarm_topic_arn
}
