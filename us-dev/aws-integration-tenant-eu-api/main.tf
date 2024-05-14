terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tfstate"
    key            = "aws-integration-tenant-eu-api/terraform.tfstate"
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

module "lambda" {
  source                                 = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-eu-api/lambda"
  environment_tag                        = var.environment_tag
  project_tag                            = var.project_tag
  lambda_function_name                   = var.lambda_function_name
  aws_environment                        = var.aws_environment
  path_part                              = var.path_part
  us_dev_domain                          = var.us_dev_domain
  us_stage_domain                        = var.us_stage_domain
  us_prod_domain                         = var.us_prod_domain
  us_dev_mongodb_url                     = "mongodb://${var.private_ip_to_peer}:27017/"
  us_stage_mongodb_url                   = "mongodb://${var.private_ip_to_peer}:27017/"
  us_prod_mongodb_url                    = "mongodb://${var.private_ip_to_peer}:27017/"
  us_dev_mongodb_name                    = var.us_dev_mongodb_name
  us_stage_mongodb_name                  = var.us_stage_mongodb_name
  us_prod_mongodb_name                   = var.us_prod_mongodb_name
  us_dev_secret                          = var.us_dev_secret
  us_stage_secret                        = var.us_stage_secret
  us_prod_secret                         = var.us_prod_secret
  eu_stage_domain                        = var.eu_stage_domain
  eu_prod_domain                         = var.eu_prod_domain
  eu_stage_usr                           = var.eu_stage_usr
  eu_prod_usr                            = var.eu_prod_usr
  eu_stage_pwd                           = var.eu_stage_pwd
  eu_prod_pwd                            = var.eu_prod_pwd
  collection_name                        = var.collection_name
  api_endpoint                           = var.api_endpoint
  aws_backend_private_subnet1_id         = data.terraform_remote_state.modules.outputs.aws_backend_private_subnet1_id
  aws_backend_private_subnet2_id         = data.terraform_remote_state.modules.outputs.aws_backend_private_subnet2_id
  aws_backend_security_group2_id         = data.terraform_remote_state.modules.outputs.aws_backend_security_group2_id
  aws_backend_load_balancer_listener_arn = data.terraform_remote_state.modules.outputs.aws_backend_load_balancer_listener_arn
}

module "api_gateway" {
  source                                = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-eu-api/api_gateway"
  environment_tag                       = var.environment_tag
  project_tag                           = var.project_tag
  aws_environment                       = var.aws_environment
  path_part                             = var.path_part
  aws_backend_public_subnet1_id         = data.terraform_remote_state.modules.outputs.aws_backend_public_subnet1_id
  aws_backend_public_subnet2_id         = data.terraform_remote_state.modules.outputs.aws_backend_public_subnet2_id
  aws_backend_security_group1_id        = data.terraform_remote_state.modules.outputs.aws_backend_security_group1_id
  aws_backend_load_balancer_listener_id = data.terraform_remote_state.modules.outputs.aws_backend_load_balancer_listener_id
}

module "budgets" {
  source                          = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-eu-api/budgets"
  environment_tag                 = var.environment_tag
  project_tag                     = var.project_tag
  budget_alert_topic_arn          = data.terraform_remote_state.modules.outputs.budget_alert_topic_arn
  lambda_budget_limit_amount      = var.lambda_budget_limit_amount
  lambda_budget_time_unit         = var.lambda_budget_time_unit
  api_gateway_budget_limit_amount = var.api_gateway_budget_limit_amount
  api_gateway_budget_time_unit    = var.api_gateway_budget_time_unit
}

module "cloudwatch" {
  source                     = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-eu-api/cloudwatch"
  environment_tag            = var.environment_tag
  project_tag                = var.project_tag
  cloudwatch_alarm_topic_arn = data.terraform_remote_state.modules.outputs.cloudwatch_alarm_topic_arn
}