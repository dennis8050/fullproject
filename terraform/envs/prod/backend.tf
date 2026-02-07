terraform {
  backend "s3" {
    bucket         = "terraformstatefile-prod"
    key            = "prod/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}
