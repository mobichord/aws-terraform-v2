terraform {
    cloud {
    organization = "aws-projs"

    workspaces {
      name = "us-dev"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "github" {
  token = var.github_token
}

# this vpc should only be ran once for the entire repo
module "vpc" {
  source                     = "github.com/mobichord/aws-terraform-v2/us-dev/modules/vpc"
  aws_region                 = var.aws_region
  vpc_cidr_block             = var.vpc_cidr_block
  private_subnet1_cidr_block = var.private_subnet1_cidr_block
  private_subnet2_cidr_block = var.private_subnet2_cidr_block
  public_subnet1_cidr_block  = var.public_subnet1_cidr_block
  public_subnet2_cidr_block  = var.public_subnet2_cidr_block
  private_subnet1_az         = var.private_subnet1_az
  private_subnet2_az         = var.private_subnet2_az
  public_subnet1_az          = var.public_subnet1_az
  public_subnet2_az          = var.public_subnet2_az
  vpc_id_to_peer             = var.vpc_id_to_peer
  private_ip_to_peer         = var.private_ip_to_peer
  cidr_block_of_vpc_to_peer  = var.cidr_block_of_vpc_to_peer
  environment_tag            = var.environment_tag
}

module "lambda" {
  source                         = "github.com/mobichord/aws-terraform-v2/us-dev/aws-mongodb-get-api/lambda"
  environment_tag                = var.environment_tag
  project_tag                    = var.project_tag
  mongodb_url                    = "mongodb://${var.private_ip_to_peer}:27017/"
  mongodb_name                   = var.mongodb_name
  aws_backend_private_subnet1_id = module.vpc.aws_backend_private_subnet1_id
  aws_backend_private_subnet2_id = module.vpc.aws_backend_private_subnet2_id
  aws_backend_security_group2_id = module.vpc.aws_backend_security_group2_id
}

module "alb" {
  source                         = "github.com/mobichord/aws-terraform-v2/us-dev/modules/alb"
  environment_tag                = var.environment_tag
  aws_environment                = var.aws_environment
  path_part                      = var.path_part
  aws_backend_private_subnet1_id = module.vpc.aws_backend_private_subnet1_id
  aws_backend_private_subnet2_id = module.vpc.aws_backend_private_subnet2_id
  aws_backend_public_subnet1_id  = module.vpc.aws_backend_public_subnet1_id
  aws_backend_public_subnet2_id  = module.vpc.aws_backend_public_subnet2_id
  aws_backend_security_group1_id = module.vpc.aws_backend_security_group1_id
  aws_mongodb_ga_function_arn    = module.lambda.aws_mongodb_ga_function_arn
}

module "api_gateway" {
  source                                = "github.com/mobichord/aws-terraform-v2/us-dev/aws-mongodb-get-api/api_gateway"
  environment_tag                       = var.environment_tag
  project_tag                           = var.project_tag
  aws_region                            = var.aws_region
  aws_environment                       = var.aws_environment
  path_part                             = var.path_part
  mongodb_name                          = var.mongodb_name
  aws_backend_public_subnet1_id         = module.vpc.aws_backend_public_subnet1_id
  aws_backend_public_subnet2_id         = module.vpc.aws_backend_public_subnet2_id
  aws_backend_security_group1_id        = module.vpc.aws_backend_security_group1_id
  aws_backend_load_balancer_listener_id = module.alb.aws_backend_load_balancer_listener_id
}

module "sns" {
  source                   = "github.com/mobichord/aws-terraform-v2/us-dev/modules/sns"
  environment_tag          = var.environment_tag
  recipient_for_budgets    = var.recipient_for_budgets
  recipient_for_cloudwatch = var.recipient_for_cloudwatch
}

module "budgets" {
  source                          = "github.com/mobichord/aws-terraform-v2/us-dev/aws-mongodb-get-api/budgets"
  environment_tag                 = var.environment_tag
  project_tag                     = var.project_tag
  budget_alert_topic_arn          = module.sns.budget_alert_topic_arn
  lambda_budget_limit_amount      = var.lambda_budget_limit_amount
  lambda_budget_time_unit         = var.lambda_budget_time_unit
  api_gateway_budget_limit_amount = var.api_gateway_budget_limit_amount
  api_gateway_budget_time_unit    = var.api_gateway_budget_time_unit
}

module "cloudwatch" {
  source                     = "github.com/mobichord/aws-terraform-v2/us-dev/aws-mongodb-get-api/cloudwatch"
  environment_tag            = var.environment_tag
  project_tag                = var.project_tag
  cloudwatch_alarm_topic_arn = module.sns.cloudwatch_alarm_topic_arn
}