output "aws_backend_load_balancer_arn" {
  description = "The ARN of the Load Balancer."
  value       = aws_lb.aws_backend_load_balancer.arn
}

output "aws_backend_load_balancer_uri" {
  description = "The URI of the Load Balancer."
  value       = aws_lb.aws_backend_load_balancer.dns_name
}

output "aws_backend_load_balancer_name" {
  description = "The name of the Load Balancer."
  value       = aws_lb.aws_backend_load_balancer.name
}

output "aws_backend_load_balancer_listener_id" {
  description = "The ID of the Load Balancer Listener."
  value       = aws_lb_listener.aws_backend_load_balancer_listener.id
}

output "aws_backend_load_balancer_target_group1_arn" {
  description = "The ARN of the Load Balancer's target group."
  value       = aws_lb_target_group.aws_backend_load_balancer_target_group1.arn
}
