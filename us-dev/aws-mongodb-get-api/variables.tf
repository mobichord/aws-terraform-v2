########## common variables ##########

variable "aws_region" {
  type        = string
  description = "Designated AWS_REGION where this solution will be deployed."
}

variable "aws_access_key" {
  type        = string
  description = "Access key for the AWS profile."
}

variable "aws_secret_key" {
  type        = string
  description = "Secret key for the AWS profile."
}

variable "environment_tag" {
  type        = string
  description = "Provide which environment this will be deployed. Used for tagging the resources created."
}

variable "project_tag" {
  type        = string
  description = "Provide the repository name. Used for tagging the resources created."
}

variable "github_token" { # this token needs to be generated in the github's developer settings with a read:project permission.
  type        = string
  description = "Token to authenticate the use of github links as the source path for the modules."
}

########## modules/vpc ##########

variable "vpc_cidr_block" {
  type        = string
  description = "Designated CIDR block of VPC to be created."
}

variable "private_subnet1_cidr_block" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-1 to be created."
}

variable "private_subnet2_cidr_block" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-2 to be created."
}

variable "public_subnet1_cidr_block" {
  type        = string
  description = "Designated CIDR block of aws-backend-public-subnet-1 to be created."
}

variable "public_subnet2_cidr_block" {
  type        = string
  description = "Designated CIDR block of aws-backend-public-subnet-2 to be created."
}

variable "private_subnet1_az" {
  type        = string
  description = "Designated availability zone of aws-backend-private-subnet-1 to be created."
}

variable "private_subnet2_az" {
  type        = string
  description = "Designated availability zone of aws-backend-private-subnet-2 to be created."
}

variable "public_subnet1_az" {
  type        = string
  description = "Designated availability zone of aws-backend-public-subnet-1 to be created."
}

variable "public_subnet2_az" {
  type        = string
  description = "Designated availability zone of aws-backend-public-subnet-2 to be created."
}

variable "vpc_id_to_peer" {
  type        = string
  description = "ID of the VPC to peer with."
}

variable "private_ip_to_peer" {
  type        = string
  description = "Private IPv4 of the VPC to communicate with."
}

variable "cidr_block_of_vpc_to_peer" {
  type        = string
  description = "CIDR block of the peered VPC to add for routing tables."
}

########## aws-mongodb-get-api/lambda ##########

variable "mongodb_name" {
  type        = string
  description = "Database name for the lambda to query with."
}

########## aws-mongodb-get-api/api_gateway ##########

variable "aws_environment" {
  type        = string
  description = "Designated AWS_ENV where this solution will be deployed."
}

variable "path_part" {
  type        = string
  description = "Path part of the API endpoint."
  default     = "documents"
}

########## modules/sns ##########

variable "recipient_for_budgets" {
  type        = string
  description = "The recipient of the budget alerts when the threshold exceeds."
}

variable "recipient_for_cloudwatch" {
  type        = string
  description = "The recipient of the cloudwatch alarms when there is an error."
}

########## aws-mongodb-get-api/budgets ##########

variable "lambda_budget_limit_amount" {
  type        = string
  description = "The amount of cost or usage being measured for for the aws-mongodb-ga-function."
}

variable "lambda_budget_time_unit" {
  type        = string
  description = "The length of time until a budget resets the actual and forecasted spend for the aws-mongodb-ga-function."
}

variable "api_gateway_budget_limit_amount" {
  type        = string
  description = "The threshold set for the aws-mongodb-ga-api."
}

variable "api_gateway_budget_time_unit" {
  type        = string
  description = "The length of time until a budget resets the actual and forecasted spend for the aws-mongodb-ga-api."
}