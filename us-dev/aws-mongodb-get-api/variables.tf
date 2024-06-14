########## common variables ##########

variable "prefix_name" {
  type = string
}

variable "aws_region" {
  type        = string
  description = "Designated AWS_REGION where this solution will be deployed."
}

variable "aws_profile" {
  type        = string
  description = "Provide the repository name. Used for tagging the resources created."
  default     = "terraform-aws-platform"
}

variable "aws_role_arn" {
  type        = string
  description = "Provide the repository name. Used for tagging the resources created."
}

variable "aws_session_role" {
  type        = string
  description = "Provide the repository name. Used for tagging the resources created."
}

# variable "aws_access_key" {
#   type        = string
#   description = "Access key for the AWS profile."
# }

# variable "aws_secret_key" {
#   type        = string
#   description = "Secret key for the AWS profile."
# }

variable "environment_tag" {
  type        = string
  description = "Provide which environment this will be deployed. Used for tagging the resources created."
}

variable "project_tag" {
  type        = string
  description = "Provide the repository name. Used for tagging the resources created."
}

# variable "github_token" { # this token needs to be generated in the github's developer settings with a read:project permission.
#   type        = string
#   description = "Token to authenticate the use of github links as the source path for the modules."
# }

########## modules/vpc ##########

########## aws-mongodb-get-api/lambda ##########

variable "mongodb_url" {
  type        = string
  description = "Connection string of the MongoDB to connect with."
} #ipaddress mongodb - (eks node)

variable "mongodb_name" {
  type        = string
  description = "Database name for the lambda to query with."
} #emi

########## aws-mongodb-get-api/api_gateway ##########

variable "stage_name" {
  type        = string
  description = "Stage where this solution will be deployed."
} #us-dev #environment only

variable "path_part" {
  type        = string
  description = "Path part of the API endpoint."
  default     = "documents"
}

########## aws-mongodb-get-api/budgets ##########

variable "lambda_budget_limit_amount" {
  type        = string
  description = "The amount of cost or usage being measured for for the aws-mongodb-ga-function."
} # 1

variable "lambda_budget_time_unit" {
  type        = string
  description = "The length of time until a budget resets the actual and forecasted spend for the aws-mongodb-ga-function."
} #DAILY

variable "api_gateway_budget_limit_amount" {
  type        = string
  description = "The threshold set for the aws-mongodb-ga-api."
} # 1

variable "api_gateway_budget_time_unit" {
  type        = string
  description = "The length of time until a budget resets the actual and forecasted spend for the aws-mongodb-ga-api."
} # DAILY