output "aws_mongodb_ga_api_endpoint" {
  description = "HTTP API endpoint for aws-mongodb-ga-api"
  value       = "https://${module.api_gateway.aws_mongodb_ga_api_id}.execute-api.${var.aws_region}.amazonaws.com/${var.stage_name}/${var.path_part}"
}