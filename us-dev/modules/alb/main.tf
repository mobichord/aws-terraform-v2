resource "aws_lb" "aws_backend_load_balancer" {
  name               = "aws-backend-lb"
  internal           = true
  security_groups    = [
    var.aws_backend_security_group1_id
    ]
  subnets            = [
    var.aws_backend_private_subnet1_id,
    var.aws_backend_private_subnet2_id,
    var.aws_backend_public_subnet1_id,
    var.aws_backend_public_subnet2_id,
  ]
  tags = {
    Name       = "aws-backend-lb"
    CostCenter = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_lb_target_group" "aws_backend_load_balancer_target_group1" {
  name     = "aws-backend-lb-target-group-1"
  port     = 80
  protocol = "HTTP"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "lambda_attachment" {
  depends_on = [ aws_lb_target_group.aws_backend_load_balancer_target_group1 ]
  target_group_arn = aws_lb_target_group.aws_backend_load_balancer_target_group1.arn
  target_id        = var.aws_mongodb_ga_function_arn
}

resource "aws_lb_listener" "aws_backend_load_balancer_listener" {
  load_balancer_arn = aws_lb.aws_backend_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type    = "application/json"
      status_code     = "404"
      message_body    = "The URL you requested could not be found."
    }
  }
}

resource "aws_lb_listener_rule" "aws_backend_listener_rule1" {
  listener_arn = aws_lb_listener.aws_backend_load_balancer_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_backend_load_balancer_target_group1.arn
  }

  condition {
    path_pattern {
      values = ["/${var.aws_environment}/${var.path_part}"]
    }
  }
}