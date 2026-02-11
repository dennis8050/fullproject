terraform {
  backend "s3" {
    bucket         = "terraformstatefile-prod1"
    key            = "prod/infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
