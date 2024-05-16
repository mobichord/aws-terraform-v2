variable "prefix_name" {
  type = string
}

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

variable "aws_backend_load_balancer_arn" {
  type        = string
  description = "The ARN of the Load Balancer."
}

variable "aws_backend_load_balancer_dns_name" {
  type        = string
  description = "The URI of the Load Balancer."
}

variable "aws_backend_vpc_endpoint_id" {
  type        = string
  description = "The ID of the AwsBackendVpcEndpoint."
}

variable "aws_backend_vpc_endpoint_arn" {
  type        = string
  description = "The ARN of the AwsBackendVpcEndpoint."
}

variable "aws_mongodb_ga_function_invoke_arn" {
  type        = string
  description = "The Invoke ARN of the underlying Lambda function."
}