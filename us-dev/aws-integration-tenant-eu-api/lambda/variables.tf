variable "cost_center_tag" {
  type        = string
  description = "Used for tagging the resources created."
  default     = "AWSDevAccount"
}

variable "environment_tag" {
  type        = string
  description = "Provide which environment this will be deployed. Used for tagging the resources created."
}

variable "project_tag" {
  type        = string
  description = "Provide the repository name. Used for tagging the resources created."
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda's function name."
  default     = "aws-integration-tenant-eu-function"
}

# oregon variables

variable "us_dev_domain" {
  type        = string
  description = "Domain address of the us-dev."
}

variable "us_stage_domain" {
  type        = string
  description = "Domain address of the us-stage."
}

variable "us_prod_domain" {
  type        = string
  description = "Domain address of the us-prod."
}

variable "us_dev_mongodb_url" {
  type        = string
  description = "Connection string of the us-dev MongoDB to connect with."
}

variable "us_stage_mongodb_url" {
  type        = string
  description = "Connection string of the us-stage MongoDB to connect with."
}

variable "us_prod_mongodb_url" {
  type        = string
  description = "Connection string of the us-prod MongoDB to connect with."
}

variable "us_dev_mongodb_name" {
  type        = string
  description = "Database name in us-dev for the lambda to query with."
}

variable "us_stage_mongodb_name" {
  type        = string
  description = "Database name in us-stage for the lambda to query with."
}

variable "us_prod_mongodb_name" {
  type        = string
  description = "Database name in us-prod for the lambda to query with."
}

variable "us_dev_secret" {
  type        = string
  description = "Secret used in us-dev."
}

variable "us_stage_secret" {
  type        = string
  description = "Secret used in us-stage."
}

variable "us_prod_secret" {
  type        = string
  description = "Secret used in us-prod."
}

# frankfurt variables

variable "eu_stage_domain" {
  type        = string
  description = "Domain address of the eu-stage."
}

variable "eu_prod_domain" {
  type        = string
  description = "Domain address of the eu-prod."
}

variable "eu_stage_usr" {
  type        = string
  description = "Admin tenant's username used in eu-stage."
}

variable "eu_prod_usr" {
  type        = string
  description = "Admin tenant's username used in eu-prod."
}

variable "eu_stage_pwd" {
  type        = string
  description = "Admin tenant's password used in eu-stage."
}

variable "eu_prod_pwd" {
  type        = string
  description = "Admin tenant's password used in eu-prod."
}

# query variables

variable "collection_name" {
  type        = string
  description = "Collection name as part of the query."
}

variable "api_endpoint" {
  type        = string
  description = "API endpoint to trigger the tenant creation."
}

variable "aws_environment" {
  type        = string
  description = "Designated AWS_ENV where this solution will be deployed."
}

variable "path_part" {
  type        = string
  description = "Path part of the API endpoint."
}

variable "aws_backend_private_subnet1_id" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-1 to be created."
}

variable "aws_backend_private_subnet2_id" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-2 to be created."
}

variable "aws_backend_security_group2_id" {
  type        = string
  description = "Designated security group of lambdas in aws-backend-vpc."
}

variable "aws_backend_load_balancer_listener_arn" {
  type        = string
  description = "The ARN of the Load Balancer Listener."
}