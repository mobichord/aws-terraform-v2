output "aws_mongodb_ga_api_endpoint" {
  description = "HTTP API endpoint for aws-mongodb-ga-api"
  value       = "https://${aws_apigatewayv2_api.aws_mongodb_ga_api.api_endpoint}.${var.aws_region}.amazonaws.com/${aws_apigatewayv2_stage.aws_mongodb_ga_api_stage.name}/${var.path_part}"
}