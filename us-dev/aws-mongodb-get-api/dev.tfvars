prefix_name = "aws-backend"
aws_region = "us-west-2"
environment_tag = "UsDev"
project_tag = "aws-mongodb-get-api"
mongodb_url = "10.1.23.54"
mongodb_name = "emi"
stage_name = "us-dev"
path_part = "documents"
lambda_budget_limit_amount = "1"
lambda_budget_time_unit = "DAILY"
api_gateway_budget_limit_amount = "1"
api_gateway_budget_time_unit = "DAILY"

aws_profile = "terraform-aws-platform"
aws_role_arn = "arn:aws:iam::747361732723:role/aws-terraform-platform-role"
aws_session_role = "TerraformSession"

# mongodb_ip = ["10.1.22.198/32", "10.1.18.163/32"]