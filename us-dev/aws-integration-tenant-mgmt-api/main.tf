terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tfstate"
    key            = "aws-integration-tenant-mgmt-api/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "aws-backend-tf-lockid"
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "github" {
  token = var.github_token
}

data "terraform_remote_state" "modules" {
  backend = "s3"

  config = {
    bucket = "aws-backend-tfstate"
    key    = "modules/terraform.tfstate"
    region = "us-west-2"
  }
}

module "vpc" {
  source                             = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-mgmt-api/vpc"
  prefix_name                        = var.prefix_name
  aws_region                         = var.aws_region
  aws_backend_private_route_table_id = data.terraform_remote_state.modules.outputs.aws_backend_private_route_table_id
  aws_backend_public_subnet1_id      = data.terraform_remote_state.modules.outputs.aws_backend_public_subnet1_id
}

module "lambda" {
  source                         = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-mgmt-api/lambda"
  prefix_name                    = var.prefix_name
  environment_tag                = var.environment_tag
  project_tag                    = var.project_tag
  lambda_function_name           = var.lambda_function_name
  stage_name                     = var.stage_name
  path_part                      = var.path_part
  mongodb_domain                 = var.mongodb_domain
  mongodb_url                    = var.mongodb_url
  mongodb_name                   = var.mongodb_name
  env_secret                     = var.env_secret
  us_dev_domain                  = var.us_dev_domain
  us_stage_domain                = var.us_stage_domain
  us_prod_domain                 = var.us_prod_domain
  eu_stage_domain                = var.eu_stage_domain
  eu_prod_domain                 = var.eu_prod_domain
  us_dev_usr                     = var.us_dev_usr
  us_dev_pwd                     = var.us_dev_pwd
  us_staging_usr                 = var.us_staging_usr
  us_staging_pwd                 = var.us_staging_pwd
  us_prod_usr                    = var.us_prod_usr
  us_prod_pwd                    = var.us_prod_pwd
  eu_staging_usr                 = var.eu_staging_usr
  eu_staging_pwd                 = var.eu_staging_pwd
  eu_prod_usr                    = var.eu_prod_usr
  eu_prod_pwd                    = var.eu_prod_pwd
  collection_name                = var.collection_name
  api_endpoint                   = var.api_endpoint
  aws_backend_private_subnet1_id = data.terraform_remote_state.modules.outputs.aws_backend_private_subnet1_id
  aws_backend_private_subnet2_id = data.terraform_remote_state.modules.outputs.aws_backend_private_subnet2_id
  aws_backend_security_group2_id = data.terraform_remote_state.modules.outputs.aws_backend_security_group2_id
}

module "api_gateway" {
  source                                          = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-mgmt-api/api_gateway"
  prefix_name                                     = var.prefix_name
  environment_tag                                 = var.environment_tag
  project_tag                                     = var.project_tag
  stage_name                                      = var.stage_name
  path_part                                       = var.path_part
  aws_integration_tenant_mgmt_function_invoke_arn = module.lambda.aws_integration_tenant_mgmt_function_invoke_arn
  aws_backend_vpc_endpoint_id                     = data.terraform_remote_state.modules.outputs.aws_backend_vpc_endpoint_id
}

module "budgets" {
  source                          = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-mgmt-api/budgets"
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
  source                     = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-mgmt-api/cloudwatch"
  prefix_name                = var.prefix_name
  environment_tag            = var.environment_tag
  project_tag                = var.project_tag
  cloudwatch_alarm_topic_arn = data.terraform_remote_state.modules.outputs.cloudwatch_alarm_topic_arn
}