profile        = "terraform-aws-platform"
bucket         = "aws-platform-terraform-statefile"
key            = "modules/terraform.tfstate"
region         = "us-west-2"
encrypt        = true
dynamodb_table = "aws-platform-terraform-lockstate"